class AddressInputGroup < FormInputGroup

  RESOURCE = :personal_addresses

  VALID_INPUTS = [
    'address_type',
    'primary',
    'address_lines',
    'locality',
    'region',
    'postal_code',
    'country',
    'venue',
  ].freeze

  ALIASES = HashWithIndifferentAccess.new(
    address_lines: 'address',
    locality: 'city',
    region: 'state',
  ).freeze

end
