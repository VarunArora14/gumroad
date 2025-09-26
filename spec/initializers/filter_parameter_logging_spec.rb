# frozen_string_literal: true

require "spec_helper"

RSpec.describe "FilterParameterLogging" do
  describe "parameter filtering configuration" do
    let(:filter) { ActiveSupport::ParameterFilter.new(Rails.application.config.filter_parameters) }

    it "includes comprehensive sensitive parameter filtering" do
      # Test that our configuration includes the expected sensitive parameters
      expected_sensitive_params = %w[
        password secret token auth authorization api_key private_key public_key
        certificate key_id session_id csrf_token pin cvv security_code
        verification_code otp two_factor cc_number access_token refresh_token
      ]

      filter_parameters = Rails.application.config.filter_parameters.map(&:to_s)

      expected_sensitive_params.each do |param|
        expect(filter_parameters).to include(param)
      end
    end

    it "filters sensitive parameters in nested structures" do
      params = {
        user: {
          name: "John",
          password: "secret123",
          api_key: "sk_test_123"
        },
        payment: { cc_number: "4111111111111111", amount: 1000 }
      }

      filtered = filter.filter(params)

      expect(filtered[:user][:name]).to eq("John")
      expect(filtered[:user][:password]).to eq("[FILTERED]")
      expect(filtered[:user][:api_key]).to eq("[FILTERED]")
      expect(filtered[:payment][:cc_number]).to eq("[FILTERED]")
      expect(filtered[:payment][:amount]).to eq(1000)
    end

    it "preserves non-sensitive parameters" do
      params = { username: "john_doe", email: "test@example.com", price_cents: 1000 }
      filtered = filter.filter(params)
      expect(filtered).to eq(params)
    end
  end
end
