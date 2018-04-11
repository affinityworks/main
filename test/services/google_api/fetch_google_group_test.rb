require_relative "../../test_helper"

class GoogleAPI::CreateGoogleGroupTest < ActiveSupport::TestCase
  let(:directory_service_double){ double(Google::Apis::AdminDirectoryV1::DirectoryService) }
  let(:google_group_double){ double(Google::Apis::AdminDirectoryV1::Group) }

  describe ".call" do
    before do
      expect(GoogleAPI::BuildDirectoryService)
        .to receive(:call).and_return(directory_service_double)
      expect(directory_service_double)
        .to receive(:get_group).and_return(google_group_double)
    end

    it "fetches a google group from google's api directory service" do
      GoogleAPI::FetchGoogleGroup.call(
        authorization: double(Google::Auth::ServiceAccountCredentials),
        group_key: 'does not matter'
      ).must_equal google_group_double
    end
  end
end
