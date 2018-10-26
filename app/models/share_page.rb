class SharePage < ApplicationRecord
  belongs_to :creator, :class_name => "Person", optional: true
  belongs_to :modified_by, :class_name => "Person", optional: true

  has_many :facebook_shares
  has_many :twitter_shares
  has_many :email_shares
end
