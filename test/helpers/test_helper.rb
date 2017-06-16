ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/rails'
require "minitest/reporters"
reporter_options = {color: true, slow_count: 5}
Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new(:color => true, :slow_count => 5)]

class ActiveSupport::TestCase
  # Setup all fixtures in text/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Returns true if a test user is logged in.
  def is_logged_in?
    !session[:user_id].nil?
  end

end
