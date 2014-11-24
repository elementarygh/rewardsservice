ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def valid_token
    ct_array = Figaro.env.client_tokens.split(',')
    token = ct_array.blank? ? "No_valid_token_found" : ct_array[rand(0...ct_array.length)]
    "Token token=#{token}"
  end

  def invalid_token
    "Token token=some_invalid_token"
  end

  def json
    @json ||= JSON.parse(response.body)
  end

  def rewards
    @rewards ||= json.collect { |x| x["reward"] }
  end
  
end
