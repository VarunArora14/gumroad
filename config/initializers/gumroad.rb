# frozen_string_literal: true

GUMROAD_VAT_REGISTRATION_NUMBER = GlobalConfig.get("VAT_REGISTRATION_NUMBER", "EU826410924")
GUMROAD_AUSTRALIAN_BUSINESS_NUMBER = GlobalConfig.get("AUSTRALIAN_BUSINESS_NUMBER", "11 374 928 117")
GUMROAD_CANADA_GST_REGISTRATION_NUMBER = GlobalConfig.get("CANADA_GST_REGISTRATION_NUMBER", "701850612 RT9999")
GUMROAD_QST_REGISTRATION_NUMBER = GlobalConfig.get("QST_REGISTRATION_NUMBER", "NR00086053")
GUMROAD_NORWAY_VAT_REGISTRATION = GlobalConfig.get("NORWAY_VAT_REGISTRATION", "VOEC NO. 2082039")

# TODO: This is a placeholder for other tax registration numbers.
# As we activate "collect_tax_*" features, we'll need to add the appropriate
# tax registration number here for each country. (curtiseinsmann)
GUMROAD_OTHER_TAX_REGISTRATION = GlobalConfig.get("OTHER_TAX_REGISTRATION", "OTHER")

REPORTING_S3_BUCKET = if Rails.env.production?
  GlobalConfig.get("REPORTING_S3_BUCKET_PROD", "gumroad-reporting")
else
  GlobalConfig.get("REPORTING_S3_BUCKET_DEV", "gumroad-reporting-dev")
end

GUMROAD_MERCHANT_DESCRIPTOR_PHONE_NUMBER = GlobalConfig.get("MERCHANT_DESCRIPTOR_PHONE", "(650)742-3913") # Must be 10-14
GUMROAD_MERCHANT_DESCRIPTOR_URL = GlobalConfig.get("MERCHANT_DESCRIPTOR_URL", "gumroad.com/c") # Must be 0-13

GUMROAD_LOGO_URL = GlobalConfig.get("LOGO_URL", "https://gumroad.com/button/button_logo.png")

module GumroadAddress
  STREET = "548 Market St"
  CITY = "San Francisco"
  STATE = "CA"
  ZIP = "94104"
  ZIP_PLUS_FOUR = "9401-5401"

  # Normalize configured country and try multiple lookups; fallback to US
  configured_country = GlobalConfig.get("ADDRESS_COUNTRY", "US").to_s.strip
  resolved_country = begin
    ISO3166::Country[configured_country.upcase] ||
      ISO3166::Country.find_country_by_alpha3(configured_country.upcase) ||
      ISO3166::Country.find_country_by_name(configured_country)
  rescue StandardError
    nil
  end
  COUNTRY = resolved_country || ISO3166::Country["US"]

  def self.full
    country_code = COUNTRY&.alpha3 || "USA"
    "#{STREET}, #{CITY}, #{STATE} #{ZIP_PLUS_FOUR}, #{country_code}"
  end
end
