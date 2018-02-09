class PhoneInputGroup < FormInputGroup

  RESOURCE = :phone_numbers

  VALID_INPUTS = [
    'number_type',
    'primary',
    'number',
    'extension',
    'country',
    'sms_capable',
    'operator',
    'description',
  ].freeze

  ALIASES = HashWithIndifferentAccess.new(
    number_type: 'phone number type',
    number: 'phone number'
  ).freeze

end
