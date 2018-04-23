require_relative "../../test_helper"

class Subgroups::AferCreateTest < ActiveSupport::TestCase
  describe ".call" do
    let(:person){ double(Person, email: "foo@bar.com") }
    let(:group) do
      double(Group,
             name: "foo",
             primary_network: double(Network),
             build_google_group_email: "foo@bar.com")
    end

    before do
      allow(OrganizerMailer).to receive_message_chain(:new_subgroup_email, :deliver_later)
      allow(SignupForm).to receive(:for)
    end

    it "calls OrganizerMailer" do
      expect(OrganizerMailer).to receive_message_chain(:new_subgroup_email, :deliver_later)

      Subgroups::AfterCreate.call(organizer: Person.new, subgroup: Group.new)
    end

    describe "gsuite feature toggle is on" do
      before { allow(FeatureToggle).to receive(:on?).and_return(true) }

      it "calls GoogleAPI services if authorization is successful" do
        # NOTE: (aguestuser|11 Apr 2018)
        # - IMHO, these are brittle (arguably anemic) tests
        # - evidence: a working refactor caused need for substantial re-writes
        # - i think a browser test suffices (and is more flexible)
        # - :. i am no writing similar tests for `Signups::AfterCreate`
        # - happy to discuss and be proven wrong! :D
        expect(GoogleAPI::Service)
          .to receive_message_chain(
                :new,
                :authenticate,
                :create_google_group,
                :save_google_group,
                :add_member_to_google_group
              )
        Subgroups::AfterCreate.call(organizer: person, subgroup: group)
      end
    end

    describe "gsuite feature toggle is off" do
      before { allow(FeatureToggle).to receive(:on?).and_return(false) }

      it "does not call GoogleAPI services" do
        expect(GoogleAPI::Service).to_not receive(:new)
        Subgroups::AfterCreate.call(organizer: person, subgroup: group)
      end
    end
  end
end
