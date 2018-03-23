require_relative "../../test_helper"

class GoogleAPI::CreateGoogleGroupTest < ActiveSupport::TestCase
  describe ".call" do
    it "calls build_directory_service" do
      expect(GoogleAPI::CreateGoogleGroup).to receive(:build_directory_service)
      allow(GoogleAPI::CreateGoogleGroup).to receive(:create_google_group)

      GoogleAPI::CreateGoogleGroup.call(
        authorization: double("auth"),
        group_email: "test@group.com",
        group_name: "Test Group"
      )
    end

    it "calls create_google_group" do
      allow(GoogleAPI::CreateGoogleGroup).to receive(:build_directory_service)
      expect(GoogleAPI::CreateGoogleGroup).to receive(:create_google_group)
      
      GoogleAPI::CreateGoogleGroup.call(
        authorization: double("auth"),
        group_email: "test@group.com",
        group_name: "Test Group"
      )
    end

    it "calls insert_group on directory service" do
      directory_service = double("directory service")
      allow(GoogleAPI::CreateGoogleGroup).to receive(:build_directory_service).and_return(directory_service)
      expect(directory_service).to receive(:insert_group)
      
      GoogleAPI::CreateGoogleGroup.call(
        authorization: double("auth"),
        group_email: "test@group.com",
        group_name: "Test Group"
      )
    end
  end
end
