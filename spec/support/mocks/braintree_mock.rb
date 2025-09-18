# Braintree API mocking for offline testing
WebMock.stub_request(:any, /api\.braintreegateway\.com/).to_return do |request|
  case request.uri.path
  when /\/merchants\/.*\/transactions/
    { status: 201, body: { transaction: { id: 'bt_test', status: 'settled' } }.to_json }
  when /\/merchants\/.*\/customers/
    { status: 201, body: { customer: { id: 'bt_test_customer' } }.to_json }
  else
    { status: 200, body: { success: true }.to_json }
  end
end

# Mock Braintree configuration
if defined?(Braintree) && Braintree.respond_to?(:configure)
  Braintree.configure do |config|
    config.environment = :sandbox
    config.merchant_id = 'test_merchant_id'
    config.public_key = 'test_public_key'
    config.private_key = 'test_private_key'
  end
end