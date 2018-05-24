module SignupHandlers::CreateGroup
  PATHS = Rails.application.routes.url_helpers

  class Handler
    def initialize(args)
      @person = args[:person] # Person
      @signup_reason = args[:signup_reason] # String
      @group = args[:group] # Group,
      @subgroup_attrs = args[:subgroup_attrs] # Hash,
      @auth = args[:auth] # OmniAuth::AuthHash,
      @controller = args[:controller] # ApplicationController
      @service = args[:service] # String
    end
  end

  class NewMember < Handler
    def handle
      @controller.redirect_to(
        PATHS.oauth_signup_group_subgroups_path(
          signup_mode: @service,
          group_id: @group.id,
          subgroup: @subgroup_attrs,
          person: { oauth: Oauth.encrypt_token(@auth) }
        )
      )
    end
  end

  class InfoNeeded < Handler
    def handle
      @controller.sign_in_and_redirect_to(
        @person,
        PATHS.oauth_signup_group_subgroups_path(
          signup_mode: @service,
          group_id: @group.id,
          subgroup: @subgroup_attrs,
          person: { oauth: Oauth.encrypt_token(@auth) }
        )
      )
    end
  end

  class NoInfoNeeded < Handler
    def handle
      @controller.sign_in_and_redirect_to(
        @person,
        PATHS.oauth_signup_group_subgroups_path(
          signup_mode: @service,
          group_id: @group.id,
          subgroup: @subgroup_attrs,
          person: { oauth: Oauth.encrypt_token(@auth) }
        )
      )
    end
  end

  class Invalid < Handler
    def handle
      @controller.handle_error(PATHS.new_group_subgroup_path(group_id: @group.id))
    end
  end
end
