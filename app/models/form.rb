# == Schema Information
#
# Table name: forms
#
#  id                 :integer          not null, primary key
#  origin_system      :string
#  name               :string
#  title              :string
#  description        :string
#  summary            :string
#  call_to_action     :string
#  browser_url        :string
#  featured_image_url :string
#  total_submissions  :integer
#  person_id          :integer
#  creator_id         :integer
#  modified_by_id     :integer
#  submissions_id     :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  identifiers        :text             default([]), is an Array
#  submit_text        :string
#

class Form < ApplicationRecord

  # CONSTANTS

  REQUIRED_ATTRIBUTES = [
    :name,
    :title,
    :description,
    :call_to_action,
    :submit_text,
  ]

  DEFAULTS_BY_ATTRIBUTE = {
    submit_text: ->(obj){ obj.submit_text || 'submit' },
    name: ->(obj){ obj.name || obj.title }
  }

  #
  # ASSOCIATIONS
  #

  belongs_to :person
  belongs_to :creator, :class_name => "Person"
  has_many :submissions
  has_many :answers, :through => "Questions"

  #
  # CALLBACKS
  #

  before_validation :set_defaults

  def set_defaults
    self.assign_attributes DEFAULTS_BY_ATTRIBUTE
                             .transform_values{|v| v.call(self)}
  end

  #
  # VALIDATIONS
  #

  validates_presence_of REQUIRED_ATTRIBUTES

  validate :description_valid

  def description_valid
    if description.present?
      doc = Nokogiri::HTML(description){ |config| config.strict }
      if doc.errors.any? || doc.css("script").any?
        errors.add(:description, "must be valid HTML with no JavaScript")
      end
    end
  end
end
