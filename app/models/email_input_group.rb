class EmailInputGroup < FormInputGroup

  RESOURCE = :email_addresses

  VALID_INPUTS = [
    'primary',
    'address_type',
    'address',
  ].freeze

  ALIASES = HashWithIndifferentAccess.new(
    address_type: 'email address type',
    address: 'email address'
  ).freeze

end
