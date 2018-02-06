class AddressInputGroup < FormInputGroup

  VALID_INPUTS = [
    #'address_type',
    #'primary',
    #'address_lines', TODO: figure this out!!!!1
    'locality',
    'region',
    'postal_code',
    'country',
    #'occupation',
    #'venue',
  ].freeze

  def self.valid_inputs; VALID_INPUTS; end
  def resource; :personal_addresses; end
end
