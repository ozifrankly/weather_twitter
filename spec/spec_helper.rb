# frozen_string_literal: true

require "weather_twitter"
require 'rspec/collection_matchers'
require 'webmock/rspec'


WebMock.disable_net_connect!(allow: "api.openweathermap.org")

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def stub_get(path)
  stub_request(:get, WeatherTwitter::WeatherMap::BASE_URL + path)
end

def a_get(path)
  a_request(:get, WeatherTwitter::WeatherMap::BASE_URL + path)
end

def fixture_path
  File.expand_path('fixtures', __dir__)
end

def fixture(file)
  File.new(fixture_path + '/' + file)
end
