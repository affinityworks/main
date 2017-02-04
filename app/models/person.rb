class Person < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :email_address
  has_one :employer_address, :class_name => 'Address'

  has_many :personal_addresses, :class_name => 'Address'
  has_many :phone_numbers
  has_many :profiles
  has_many :donations
  has_many :submissions
  has_many :attendances
  has_many :events, through: :attendances
  has_many :answers
  has_many :memberships
  has_many :groups, :through => :memberships
  #validates :given_name, presence: true
  #has_many :memberships

  before_save :ensure_authentication_token

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless Person.where(authentication_token: token).exists?
    end
  end

end
