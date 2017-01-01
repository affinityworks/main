class SharePage < ApplicationRecord
  belongs_to :creator, :class_name => "Person"
  belongs_to :modified_by, :class_name => "Person"

  has_many :facebook_shares
  has_many :twitter_shares
  has_many :email_shares
end
