class EmailInputGroup < FormInputGroup

  VALID_INPUTS = [
    'primary',
    'address_type',
    'address',
  ].freeze

  def resource; :email_addresses; end
end
