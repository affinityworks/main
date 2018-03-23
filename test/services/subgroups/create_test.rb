require_relative "../../test_helper"

class Subgroups::CreateTest < ActiveSupport::TestCase
  describe ".call" do
    it "calls OrganizerMailer" do
      expect(OrganizerMailer).to receive_message_chain(:new_subgroup_email, :deliver_later)
      expect(SignupForm).to receive(:for)
      Subgroups::Create.call(organizer: Person.new, subgroup: Group.new)
    end

    describe "feature toggle for google groups is on for subgroup" do
      before do
        allow(OrganizerMailer).to receive_message_chain(:new_subgroup_email, :deliver_later)
        allow(SignupForm).to receive(:for)
        allow(FeatureToggle).to receive(:on?).and_return(true)
      end

      it "calls GoogleAPI services" do
        expect(GoogleAPI::GetAuthorization).to receive(:call)
        expect(GoogleAPI::CreateGoogleGroup).to receive(:call)
        expect(GoogleAPI::UpdateGoogleGroupSettings).to receive(:call)
        expect(GoogleAPI::AddMemberToGoogleGroup).to receive(:call)

        Subgroups::Create.call(organizer: Person.new, subgroup: Group.new(name: "Test Group"))
      end
    end
  end
end
