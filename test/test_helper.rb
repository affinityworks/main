ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'rspec/mocks/minitest_integration'
require 'webmock/minitest'
require "minitest/matchers"
require "minitest/autorun"
require 'minitest/focus'
require 'valid_attribute'
require_relative "./helpers/feature_test_helper"

OmniAuth.config.test_mode = true

class ActiveSupport::TestCase
  include ::ValidAttribute::Method
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  # support active job helpers (like `perform_enqueued_jobs`)
  include ActiveJob::TestHelper

  # Add more helper methods to be used by all tests here...
end


class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
end
