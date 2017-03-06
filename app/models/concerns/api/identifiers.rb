module Api::Identifiers
  extend ActiveSupport::Concern

  included do
    after_create :add_identifier

    scope :any_identifier, ->(identifier) { where('? = any (identifiers)', identifier) }

    # Older copy of a record from a foreign system?
    # If local updated_at is more recent, assume there are local modifications (and not 'outdated')
    # If local updated_at is same as foreign modified_date, assume there are no updates
    scope :outdated_existing, ->(record, system_prefix) { any_identifier(record.identifier(system_prefix)).where('updated_at < ?', record.updated_at) }
  end

  def add_identifier
    identifier = "advocacycommons:#{id}"

    if identifiers.nil?
      self.identifiers = [identifier]
      save
    elsif identifiers.include?(identifier)
      true
    else
      identifiers << identifier
      save
    end
  end

  def identifier(system_prefix)
    identifiers.detect { |i| i["#{system_prefix}:"] }
  end

  def identifier?(identifier)
    identifiers.include? identifier
  end

  def identifier_id(system_prefix)
    identifier(system_prefix)&.split(':')&.second
  end
end
