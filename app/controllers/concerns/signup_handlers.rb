module SignupHandlers
  class << self
    # args: {
    #   signup_reason: String
    #   group: Group,
    #   subgroup_attrs: Hash,
    #   auth: OmniAuth:AuthHash,
    #   controller: AppliatoinController
    #   service: String
    # }
    def for(args)
      klass_name, person = classify_person(args[:auth], args[:group])
      SignupHandlers
        .const_get(args[:signup_reason].camelize)
        .const_get(klass_name)
        .new(args.merge(person: person))
    end

    def classify_person(auth, group)
      if person = Person.find_by_email(auth.info.email)
        [classify_existing(person, group), person]
      elsif person = Person.build_from_oauth_signup(auth)
        ["NewMember", person]
      else
        ["Invalid", nil]
      end
    end

    def classify_existing(person, group)
      return "AlreadyMember" if person.is_member_of? group
      return "InfoNeeded" if person.missing_contact_info?
      return "NoInfoNeeded"
    end
  end
end
