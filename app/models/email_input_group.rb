class EmailInputGroup < FormInputGroup

  VALID_INPUTS = [
    # 'primary',
    # 'address_type',
    'address',
  ].freeze

  def self.valid_inputs; VALID_INPUTS; end
  def resource; :email_addresses; end
end
