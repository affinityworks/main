class PhoneInputGroup < FormInputGroup

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

  def resource; :phone_numbers; end

end
