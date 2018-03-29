class Network < ApplicationRecord
  # ASSOCIATIONS
  has_many :network_memberships
  has_many :members, through: :network_memberships, source: 'group'

  # VALIDATIONS
  validates :name, uniqueness: true

  validate :name_unchanged
  def name_unchanged
    if name_changed? && persisted?
      errors.add(:name, "Changing a network's name is not permitted")
    end
  end

  # NESTED ATTRIBUTES
  accepts_nested_attributes_for :members

  # CLASS METHODS
  class << self

    def find_by_snakecase_name(snakecase_name)
      find_by_name(snakecase_name&.titleize)
    end

    def import_gsuite_key(path)
      usage = "json filename must be formated as follows: " +
              "<valid_network_name_in_snake_case>.google_gsuite_key.json"

      key_regex = /([a-z_]*)_google_gsuite_key\.json/
      name = path.match(key_regex)&.send(:[], 1)
      network = Network.find_by_snakecase_name(name)
      raise usage unless network

      FileUtils.mkdir_p network.credentials_dir
      FileUtils.cp path, network.google_gsuite_key_path
      network.google_gsuite_key_path
    end
  end

  # ACCESSORS

  def name_as_md5_hash
    Digest::MD5.hexdigest snakecase_name
  end

  def credentials_dir
    # - credentials are stored as json inside of folders whose names
    #   are given as the md5 hash of the network's snakecased name
    "lib/network_credentials/#{name_as_md5_hash}"
  end

  def google_gsuite_key_path
    "#{credentials_dir}/google_gsuite_key.json"
  end

  def google_gsuite_admin_email
    Rails.configuration.networks[snakecase_name]["google_gsuite_admin_email"]
  end

  def google_gsuite_email_base
    Rails.configuration.networks[snakecase_name]["google_gsuite_email_base"]
  end

  # TODO: rename this `name_as_snakecase`
  def snakecase_name
    name.downcase.split.join("_")
  end
end
