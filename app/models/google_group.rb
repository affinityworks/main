class GoogleGroup < ApplicationRecord
  # ASSOCIATIONS
  belongs_to :group, optional: true

  # VALIDATIONS
  validates_presence_of %i[group_id group_key email url]

  # CLASS METHODS
  class << self
    def url_from(email)
      forum_name, _, hostname = email.partition("@")
      "https://groups.google.com/a/#{hostname}/forum/#!forum/#{forum_name}"
    end
  end
end
