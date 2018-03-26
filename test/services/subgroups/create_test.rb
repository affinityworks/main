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

      it "calls GoogleAPI services if authorization is successful" do
        auth = double("auth")
        auth_service = instance_double(GoogleAPI::GetAuthorization, success?: true, result: auth)
        expect(GoogleAPI::GetAuthorization).to receive(:call).and_return(auth_service)
        expect(GoogleAPI::CreateGoogleGroup).to receive(:call)
        expect(GoogleAPI::UpdateGoogleGroupSettings).to receive(:call)
        expect(GoogleAPI::AddMemberToGoogleGroup).to receive(:call)

        Subgroups::Create.call(organizer: Person.new, subgroup: Group.new(name: "Test Group"))
      end

      it "does not call GoogleAPI services if authorization is not successful" do
        auth = double("auth")
        auth_service = instance_double(GoogleAPI::GetAuthorization, success?: false, result: auth)
        allow(GoogleAPI::GetAuthorization).to receive(:call).and_return(auth_service)
        expect(GoogleAPI::CreateGoogleGroup).to_not receive(:call)
        expect(GoogleAPI::UpdateGoogleGroupSettings).to_not receive(:call)
        expect(GoogleAPI::AddMemberToGoogleGroup).to_not receive(:call)

        Subgroups::Create.call(organizer: Person.new, subgroup: Group.new(name: "Test Group"))
      end
    end
  end
end
