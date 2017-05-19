class Identity < ActiveRecord::Base
  belongs_to :person
  validates_presence_of :uid, :provider, :person_id
  validates_uniqueness_of :uid, :scope => :provider

  scope :facebook, -> { where(provider: 'facebook') }

  def self.find_for_oauth(auth)
    find_or_initialize_by(uid: auth.uid, provider: auth.provider)
  end
end
