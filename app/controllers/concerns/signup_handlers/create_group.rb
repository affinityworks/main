module SignupHandlers::CreateGroup
  PATHS = Rails.application.routes.url_helpers

  class NewMember < SignupHandlers::Handler
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

  class InfoNeeded < SignupHandlers::Handler
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

  class NoInfoNeeded < SignupHandlers::Handler
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

  class Invalid < SignupHandlers::Handler
    def handle
      @controller.handle_error(PATHS.new_group_subgroup_path(group_id: @group.id))
    end
  end
end
