module Api::ActionNetwork::Collections
  extend ActiveSupport::Concern

  included do
    attr_accessor :current_page
    attr_accessor :size
    attr_accessor :total_count
  end
end
