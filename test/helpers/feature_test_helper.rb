require "minitest/autorun"
require 'minitest/rails/capybara'

# class FeatureTest < Minitest::Capybara::Spec
class FeatureTest < ActiveSupport::TestCase
  include Minitest::Capybara::Behaviour

  include Devise::Test::IntegrationHelpers
  # setup/teardown needed for IntegrationHelpers
  # def self.setup args=nil; end
  # def self.teardown args=nil; end
  Capybara.register_driver :chrome do |app|
    Capybara::Selenium::Driver.new app, browser: :chrome
                                   #options: Selenium::Chrome::Options.new(args: %w[headless])
  end

  Capybara.javascript_driver = :chrome

  # Hash<string,string> -> Void
  def fill_out_form(values_by_input)
    values_by_input.each do |input, value|
      fill_in input, with: value
    end
  end

end
