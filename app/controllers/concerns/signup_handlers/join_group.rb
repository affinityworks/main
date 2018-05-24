module SignupHandlers::JoinGroup
  PATHS = Rails.application.routes.url_helpers

  class NewMember < SignupHandlers::Handler
    def handle
      @controller.redirect_to(
        PATHS.new_group_member_path(
          signup_mode: @service,
          group_id: @group.id,
          person: { oauth: Oauth.encrypt_token(@auth) }
        )
      )
    end
  end

  class AlreadyMember < SignupHandlers::Handler
    def handle
      @controller.flash[:notice] = "You are already a member of #{@group.name}"
      @controller.sign_in_and_redirect_to(
        @person,
        PATHS.group_dashboard_path(@group)
      )
    end
  end

  class InfoNeeded < SignupHandlers::Handler
    def handle
      @controller.sign_in_and_redirect_to(
        @person,
        PATHS.edit_group_member_path(
          signup_mode: @service,
          group_id: @group.id,
          id: @person.id,
          person: {
            oauth: Oauth.encrypt_token(@auth)
          }
        )
      )
    end
  end

  class NoInfoNeeded < SignupHandlers::Handler
    def handle
      @person.update_from_oauth_signup(
        @auth,
        { memberships:
            @person.memberships << Membership.create!(group: @group,
                                                      person: @person,
                                                      role: 'member') }
      )
      @controller.sign_in_and_redirect_to(@person, PATHS.group_dashboard_path(@group))
    end
  end

  class Invalid < SignupHandlers::Handler
    def handle
      @controller.handle_error PATHS.group_join_path(@group)
    end
  end
end
