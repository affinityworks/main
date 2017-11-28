require 'test_helper'
require 'minitest/mock'

class People::OmniauthCallbacksControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'GET #facebook' do
    person = people(:one)
    omni_auth_no_email
    identity = person.identities.take
    email = person.email
    failure_message = I18n.t("devise.omniauth_callbacks.failure", kind: "Facebook")
    success_message = I18n.t("devise.omniauth_callbacks.success", kind: "Facebook")

    get person_facebook_omniauth_callback_url
    assert_redirected_to new_person_session_url
    assert flash[:error], failure_message

    omni_auth_with_email(identity.uid, "notvalid@test.com")
    get person_facebook_omniauth_callback_url
    assert_redirected_to new_person_session_url
    assert flash[:error], failure_message

    omni_auth_with_email(identity.uid, email)
    get person_facebook_omniauth_callback_url
    assert_redirected_to profile_index_url
    assert flash[:notice], success_message

    sign_in person
    omni_auth_no_email
    get person_facebook_omniauth_callback_url
    assert_redirected_to new_person_session_url
    assert flash[:error], failure_message

  end

  def omni_auth_no_email(identity_uid=SecureRandom.uuid)
    omni_auth_object = OmniAuth::AuthHash.new(omni_auth_hash(identity_uid))
    OmniAuth.config.mock_auth[:facebook] = omni_auth_object
  end

  def omni_auth_with_email(identity_uid, email)
    omni_auth_hash = omni_auth_hash(identity_uid, email)
    omni_auth_object = OmniAuth::AuthHash.new(omni_auth_hash)
    OmniAuth.config.mock_auth[:facebook] = omni_auth_object
  end

  def omni_auth_hash(uid, email=nil)
    info = email ? { email: email } : {}
    {
      provider: "facebook",
      uid: uid,
      info: info,
      params: { group_id: "1"}
    }
  end

end
