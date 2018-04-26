# == Schema Information
#
# Table name: identities
#
#  id           :integer          not null, primary key
#  provider     :string
#  uid          :string
#  person_id    :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  access_token :string
#

class Identity < ActiveRecord::Base
  before_save :request_long_lived_token

  belongs_to :person
  validates_presence_of :uid, :provider#, :person_id
  validates_uniqueness_of :uid, :scope => :provider

  scope :facebook, -> { where(provider: 'facebook') }
  scope :twitter, -> { where(provider: 'twitter') }
  scope :google_oauth2, -> { where(provider: 'google_oauth2') }

  #
  # CLASS METHODS
  #
  class << self
    def find_for_oauth(auth)
      find_or_initialize_by(uid: auth.fetch('uid'),
                            provider: auth.fetch('provider')) do |identity|
        identity.access_token = auth.dig('credentials', 'token')
      end
    end

    def attributes_for_signup(auth)
      {
        uid: auth.fetch('uid'),
        provider: auth.fetch('provider'),
        access_token: auth.dig('credentials', 'token')
      }
    end
  end

  private

  def request_long_lived_token
    self.access_token = Facebook::Authorization.new(self).request_long_lived_token
  end
end
