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

  belongs_to :person, optional: true
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
      find_or_initialize_by(uid: auth.uid, provider: auth.provider) do |identity|
        identity.access_token = auth.credentials.token
      end
    end
  end

  private

  def request_long_lived_token
    if provider == 'facebook'
      # TODO: (aguester|26 Apr 2018)
      # - do we want to support long-lived acces tokens for google OAuth?
      # - it's the difference btw/ keeping user logged in for 2 hours & 60 days
      # - see: https://stackoverflow.com/questions/41956452/long-lived-access-token-for-google-oauth-2-0#41956680
      self.access_token = Facebook::Authorization
                            .new(self)
                            .request_long_lived_token
    end
  end
end
