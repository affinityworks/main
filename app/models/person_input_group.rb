class PersonInputGroup < FormInputGroup

  RESOURCE = :person

  VALID_INPUTS = [
    'given_name',
    'family_name',
    'birthdate',
    'employer',
    #'gender', requires dropdown
    #'gender_identity', different than gender?
    #'ethnicities',  requires new nested attribute
    #'languages_spoken',  requires new nested attribute
    #'party_identification' dropdown?
  ].freeze

  ALIASES = HashWithIndifferentAccess.new(
    given_name: 'first name',
    family_name: 'last name'
  ).freeze
end
