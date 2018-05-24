class SignupHandlers::Handler
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
