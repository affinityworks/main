class UpdateNetworksAddNationalNetwork < ActiveRecord::Migration[5.0]
  def change
    Migration.update_networks unless ENV['RAILS_ENV'] === 'test'
  end
end
