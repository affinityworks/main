require_relative "../test_helper"

class LoginTest < FeatureTest
  let(:group){ groups(:fantastic_four) }
  let(:fb_token) do
    "UwlcA5KfBMIfSXx8dYmTusAs5FNmqBDQ13L6upHh84mBua5TR7sK7eGYm9FSGz6pTdfv7xzz"+
      "iIKnPQLOEEw6icFuIFjrjSxQxHfxLpQEYWgz6zzs2U209liTg5JFRm9u7RmRzpxEaaWI9M"+
      "9u61CAh7psEMkjqsfRBFi4hm89iJ91tACuiQGxtZhKr"
  end
  let(:mock_fb_auth) do
    OmniAuth::AuthHash.new(
      { "provider"     => "facebook",
        "uid"          => "100174124183958",
        "credentials"  =>
        { "token"        => fb_token ,
          "expires_at"   => "1529880563",
          "expires"      => "true" },
        "info"         =>
        { "email"        => "organizer@admin.com",
          "name"         => "Test Organizer",
          "image"        => "http://graph.facebook.com/v2.6/"+
                            "100174124183958/picture" }
      }
    )
  end
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
        { "email"        => "organizer@admin.com",
          "name"         => "Test Organizer",
          "image"        => "https://lh6.googleusercontent.com/-nw_wxuaEA_0"+
                            "/AAAAAAAAAAI/AAAAAAAAAAc/jASoGVsZEYI/photo.jpg" },
      }
    )
  end

  before do
    OmniAuth.config.mock_auth[:facebook] = mock_fb_auth
    OmniAuth.config.mock_auth[:google_oauth2] = mock_google_auth
    visit "/admin/login"
  end

  it "has a button to login with facebook" do
    page.must_have_link "Login with Facebook",
                        href: "/admin/auth/facebook?auth_action=login"
  end

  it "has a button to login with google" do
    page.must_have_link "Login with Google",
                        href: "/admin/auth/google_oauth2?auth_action=login"
  end

  it "has a form to login with email" do
    page.find("#person_email").wont_be_nil
    page.find("#person_password").wont_be_nil
    page.must_have_button "Login with email"
  end

  describe "with email" do
    it "redirects to member homepage" do
      fill_out_form(
        "Email"    => "organizer@admin.com",
        "Password" => "password"
      )
      click_button "Login with email"
    end
  end

  describe "with facebook" do
    # TODO(aguestuser|27 Apr 2018)
    # - test sad paths covered in omniauth_callbackscontroller_test`
    #  so we can eliminate those tests for reasons noted in that file?
    # - test long-term auth token at all?
    let(:fb_auth_double){ double(Facebook::Authorization) }
    before do
      allow(Facebook::Authorization).to receive(:new).and_return(fb_auth_double)
      allow(fb_auth_double).to receive(:request_long_lived_token)
      click_link "Login with Facebook"
    end
    it "redirects to member homepage" do
      current_path.must_equal "/home"
    end
  end

  describe "with google" do
    before { click_link "Login with Google"}
    it "redirects to member homepage" do
      current_path.must_equal "/home"
    end
  end
end
