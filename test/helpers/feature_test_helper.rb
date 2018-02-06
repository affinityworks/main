require "minitest/autorun"
require 'minitest/rails/capybara'

# class FeatureTest < Minitest::Capybara::Spec
class FeatureTest < ActiveSupport::TestCase
  include Minitest::Capybara::Behaviour
  # include Devise::Test::IntegrationHelpers
  # setup/teardown needed for IntegrationHelpers
  # def self.setup args=nil; end
  # def self.teardown args=nil; end
end
