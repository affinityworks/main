class PersonInputGroup < FormInputGroup

  # CONSTANTS

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

  # CLASS METHODS

  def resource; :person; end
end
