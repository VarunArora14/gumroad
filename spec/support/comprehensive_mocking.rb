# frozen_string_literal: true

require 'webmock/rspec'

# Handle VCR if it's loaded to prevent conflicts
if defined?(VCR)
  VCR.configure do |config|
    config.hook_into :webmock
    config.ignore_localhost = true
    config.allow_http_connections_when_no_cassette = false
    # Allow WebMock to handle requests when no cassette is active
    config.ignore_request do |request|
      # Let WebMock stubs handle API calls during offline testing
      host = URI(request.uri).host
      ['api.stripe.com', 'api.paypal.com', 'api.sendgrid.com'].include?(host)
    end
  end
end

# Block ALL external network calls to force proper mocking
WebMock.disable_net_connect!(
  allow_localhost: true,
  allow: [
    '127.0.0.1',
    'localhost',
    'gumroad.dev',
    'chromedriver.storage.googleapis.com',  # Chrome driver downloads
    'api.knapsackpro.com'  # Already allowed in original spec_helper
  ]
)

# Set up basic infrastructure mocks immediately
RSpec.configure do |config|
  config.before(:each) do
    # Ensure Sidekiq is in fake mode
    Sidekiq::Testing.fake!
    
    # Clear any existing jobs
    Sidekiq::Worker.clear_all
    
    # Mock basic external services that are commonly called
    
    # Mock password breach check API
    WebMock.stub_request(:get, /api\.pwnedpasswords\.com\/range\/.+/)
      .to_return(status: 200, body: "", headers: {})
  end
end

# Load all service mocks
Dir[Rails.root.join('spec/support/mocks/*.rb')].each { |f| require f }