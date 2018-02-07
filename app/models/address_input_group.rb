class AddressInputGroup < FormInputGroup

  VALID_INPUTS = [
    'address_type',
    'primary',
    #'address_lines', TODO: need to parse joined string as array
    'locality',
    'region',
    'postal_code',
    'country',
    'venue',
  ].freeze

  def resource; :personal_addresses; end
end
