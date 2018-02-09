# == Schema Information
#
# Table name: submissions
#
#  id               :integer          not null, primary key
#  origin_system    :string
#  action_date      :datetime
#  referrer_data_id :integer
#  person_id        :integer
#  form_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  identifiers      :text             default([]), is an Array
#

class Submission < ApplicationRecord
  belongs_to :form
  belongs_to :person
  belongs_to :referrer_data
end
