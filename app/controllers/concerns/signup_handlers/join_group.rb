module SignupHandlers::JoinGroup
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
        PATHS.new_group_member_path(
          signup_mode: @service,
          group_id: @group.id,
          person: { oauth: Oauth.encrypt_token(@auth) }
        )
      )
    end
  end

  class AlreadyMember < Handler
    def handle
      @controller.flash[:notice] = "You are already a member of #{@group.name}"
      @controller.sign_in_and_redirect_to(
        @person,
        PATHS.group_dashboard_path(@group)
      )
    end
  end

  class InfoNeeded < Handler
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

  class NoInfoNeeded < Handler
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

  class Invalid < Handler
    def handle
      @controller.handle_error PATHS.group_join_path(@group)
    end
  end
end
