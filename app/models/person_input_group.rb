class PersonInputGroup < FormInputGroup

  # CONSTANTS

  VALID_INPUTS = [
    #'honorific_prefix',
    'given_name',
    'family_name',
    #'additional_name',
    #'honorific_suffix',
    'birthdate',
    #'employer',
    #'gender',
    #'gender_identity',
    #'ethnicities',
    #'languages_spoken',
    #'party_identification'
  ].freeze

  # CLASS METHODS

  def self.valid_inputs; VALID_INPUTS; end
  def resource; :person; end
end
