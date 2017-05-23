class Identity < ActiveRecord::Base
  before_save :request_long_lived_token

  belongs_to :person
  validates_presence_of :uid, :provider, :person_id
  validates_uniqueness_of :uid, :scope => :provider

  scope :facebook, -> { where(provider: 'facebook') }

  def self.find_for_oauth(auth)
    find_or_initialize_by(uid: auth.uid, provider: auth.provider) do |identity|
      identity.access_token = auth.credentials.token
    end
  end

  private

  def request_long_lived_token
    self.access_token = Facebook::Authorization.new(self).request_long_lived_token
  end
end
