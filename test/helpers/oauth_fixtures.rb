module OAuthFixtures
  extend ActiveSupport::Concern

  included do
    # facebook fixtures
    let(:facebook_token) do
      "UwlcA5KfBMIfSXx8dYmTusAs5FNmqBDQ13L6upHh84mBua5TR7sK7eGYm9FSGz6pTdfv7xzz"+
        "iIKnPQLOEEw6icFuIFjrjSxQxHfxLpQEYWgz6zzs2U209liTg5JFRm9u7RmRzpxEaaWI9M"+
        "9u61CAh7psEMkjqsfRBFi4hm89iJ91tACuiQGxtZhKr"
    end
    let(:mock_facebook_auth) do
      OmniAuth::AuthHash.new(
        { "provider"     => "facebook",
          "uid"          => "100174124183958",
          "credentials"  =>
          { "token"        => facebook_token ,
            "expires_at"   => "1529880563",
            "expires"      => "true" },
          "info"         =>
          { "email"        => "testy@affinity.works",
            "name"         => "Testy McGee",
            "image"        => "http://graph.facebook.com/v2.6/"+
                              "100174124183958/picture" }
        }
      )
    end
    let(:mock_facebook_auth_existing_user) do
      mock_facebook_auth.merge(
        "info" => {
          "email" => "organizer@admin.com",
          "name"  => "DifferentlyNamed Organizer",
          "image" => mock_facebook_auth['image']
        }
      )
    end
    let(:facebook_authorization_double){ double(Facebook::Authorization) }
    let(:stub_long_lived_access_token_request) do
      -> do
        allow(Facebook::Authorization)
          .to receive(:new)
                .and_return(facebook_authorization_double)
        allow(facebook_authorization_double)
          .to receive(:request_long_lived_token)
                .and_return(facebook_token)
      end
    end

    # google fixtures
    let(:google_token) do
      "ya29.GluqBT22iW1wYDxF1U295fvAkjpwtOBmp_Yym7rHmj0HIc3KcauH8f4a3Rdkc7SB"+
        "xcU1h9lUJjeP-PgMpLhGzpoK-W43-Q53UCqMUJjxf82qJEtjm6byTgAILyWn"
    end
    let(:mock_google_auth) do
      OmniAuth::AuthHash.new(
        { "provider"     => "google",
          "uid"          => "106985388443100843978",
          "credentials"  =>
          { "token"        => google_token ,
            "expires_at"   => "1524802515",
            "expires"      => "true" },
          "info"         =>
          { "email"        => "testy@affinity.works",
            "name"         => "Testy McGee",
            "image"        => "https://lh6.googleusercontent.com/-nw_wxuaEA_0"+
                              "/AAAAAAAAAAI/AAAAAAAAAAc/jASoGVsZEYI/photo.jpg" },
        }
      )
    end
    let(:mock_google_auth_existing_user) do
      mock_google_auth.merge(
        mock_google_auth.fetch("info").merge(
          "email" => "organizer@admin.com",
          "name"  => "Test Organizer",
        )
      )
    end
  end
end
