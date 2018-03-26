require_relative "../../test_helper"

class GoogleAPI::AddMemberToGoogleGroupTest < ActiveSupport::TestCase
  describe ".call" do
    it "calls build_directory_service" do
      expect(GoogleAPI::AddMemberToGoogleGroup).to receive(:build_directory_service)
      allow(GoogleAPI::AddMemberToGoogleGroup).to receive(:add_member_to_google_group)

      GoogleAPI::AddMemberToGoogleGroup.call(
        authorization: double("auth"),
        google_group: double("google_group"),
        email: "test@group.com"
      )
    end

    it "calls add_member_to_google_group" do
      allow(GoogleAPI::AddMemberToGoogleGroup).to receive(:build_directory_service)
      expect(GoogleAPI::AddMemberToGoogleGroup).to receive(:add_member_to_google_group)
      
      GoogleAPI::AddMemberToGoogleGroup.call(
        authorization: double("auth"),
        google_group: double("google_group"),
        email: "test@group.com"
      )
    end

    it "calls insert_member on directory service" do
      directory_service = double("directory service")
      allow(GoogleAPI::AddMemberToGoogleGroup).to receive(:build_directory_service).and_return(directory_service)
      expect(directory_service).to receive(:insert_member)
      
      GoogleAPI::AddMemberToGoogleGroup.call(
        authorization: double("auth"),
        google_group: instance_double("google group", id: 1),
        email: "test@group.com"
      )
    end
  end
end
