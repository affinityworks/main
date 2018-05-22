require_relative "../../test_helper"

class Subgroups::AferCreateTest < ActiveSupport::TestCase
  let(:person){ double(Person, email: "foo@bar.com") }
  let(:group) do
    double(Group,
           name: "foo",
           primary_network: double(Network),
           build_google_group_email: "foo@bar.com")
  end

  describe ".call" do
    before do
      allow(GroupMailer).to receive_message_chain(:join_group_email, :deliver_later)
    end

    it "calls GroupMailer" do
      expect(GroupMailer).to receive_message_chain(:join_group_email, :deliver_later)

      Subgroups::AfterCreate.call(organizer: Person.new, subgroup: Group.new)
    end

    describe "gsuite feature toggle is on" do
      before { allow(FeatureToggle).to receive(:on?).and_return(true) }

      it "calls GoogleAPI services if authorization is successful" do
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
