# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:each) do
    full_description = RSpec.current_example&.full_description || ""
    if full_description.include?("invalid UTF-8") || full_description.include?("underlying GEOIP has invalid")
      allow(GEOIP).to receive(:city).and_return(
        double(
          country: double({ name: "Unit\xB7ed States", iso_code: "U\xB7S" }),
          most_specific_subdivision: double({ iso_code: "C\xB7A" }),
          city: double({ name: "San F\xB7rancisco" }),
          postal: double({ code: "941\xB703" }),
          location: double({ latitude: "103\xB7103", longitude: "103\xB7103" })
        )
      )
    else
      allow(GeoIp).to receive(:lookup) do |ip|
        case ip
        when "76.66.210.142"
          GeoIp::Result.new(
            country_name: "Canada",
            country_code: "CA",
            region_name: "ON",
            city_name: "Toronto",
            postal_code: "M5H 2N2",
            latitude: nil,
            longitude: nil
          )
        when "54.234.242.13"
          GeoIp::Result.new(
            country_name: "United States",
            country_code: "US",
            region_name: "VA",
            city_name: "Ashburn",
            postal_code: "20147",
            latitude: nil,
            longitude: nil
          )
        when "104.193.168.19"
          GeoIp::Result.new(
            country_name: "United States",
            country_code: "US",
            region_name: "CA",
            city_name: "San Francisco",
            postal_code: "94110",
            latitude: nil,
            longitude: nil
          )
        when "2001:861:5bc0:cb60:500d:3535:e6a7:62a0"
          GeoIp::Result.new(
            country_name: "France",
            country_code: "FR",
            region_name: "25",
            city_name: "Belfort",
            postal_code: "90000",
            latitude: nil,
            longitude: nil
          )
        when "199.21.86.138"
          GeoIp::Result.new(
            country_name: "United States",
            country_code: "US",
            region_name: "CA",
            city_name: "San Francisco",
            postal_code: "94110",
            latitude: nil,
            longitude: nil
          )
        when "41.208.70.70"
          GeoIp::Result.new(
            country_name: "Libya",
            country_code: "LY",
            region_name: "TB",
            city_name: "Tripoli",
            postal_code: nil,
            latitude: nil,
            longitude: nil
          )
        when "12.12.128.128"
          GeoIp::Result.new(
            country_name: "United States",
            country_code: "US",
            region_name: "CA",
            city_name: "San Francisco",
            postal_code: "94110",
            latitude: nil,
            longitude: nil
          )
        when "109.110.31.255"
          GeoIp::Result.new(
            country_name: "Latvia",
            country_code: "LV",
            region_name: "RI",
            city_name: "Riga",
            postal_code: "LV-1001",
            latitude: nil,
            longitude: nil
          )
        when "101.198.198.0"
          GeoIp::Result.new(
            country_name: "United States",
            country_code: "US",
            region_name: "CA",
            city_name: "San Francisco",
            postal_code: "94110",
            latitude: nil,
            longitude: nil
          )
        when "127.0.0.1"
          GeoIp::Result.new(
            country_name: "United States",
            country_code: "US",
            region_name: "CA",
            city_name: "San Francisco",
            postal_code: "94110",
            latitude: nil,
            longitude: nil
          )
        when "199.241.200.176"
          GeoIp::Result.new(
            country_name: "United States",
            country_code: "US",
            region_name: "CA",
            city_name: "San Francisco",
            postal_code: "94110",
            latitude: nil,
            longitude: nil
          )
        when "193.145.138.32"
          GeoIp::Result.new(
            country_name: "Spain",
            country_code: "ES",
            region_name: "CN",
            city_name: "Las Palmas",
            postal_code: "35001",
            latitude: nil,
            longitude: nil
          )
        when "193.145.147.158"
          GeoIp::Result.new(
            country_name: "Spain",
            country_code: "ES",
            region_name: "CN",
            city_name: "Las Palmas",
            postal_code: "35001",
            latitude: nil,
            longitude: nil
          )
        when "192.168.1.1"
          GeoIp::Result.new(
            country_name: "United States",
            country_code: "US",
            region_name: "CA",
            city_name: "San Francisco",
            postal_code: "94110",
            latitude: nil,
            longitude: nil
          )
        when "2.47.255.255"
          GeoIp::Result.new(
            country_name: "Italy",
            country_code: "IT",
            region_name: "RM",
            city_name: "Rome",
            postal_code: "00100",
            latitude: nil,
            longitude: nil
          )
        when "182.23.143.254"
          GeoIp::Result.new(
            country_name: "United States",
            country_code: "US",
            region_name: "CA",
            city_name: "San Francisco",
            postal_code: "94110",
            latitude: nil,
            longitude: nil
          )
        when "93.99.163.13"
          GeoIp::Result.new(
            country_name: "Czech Republic",
            country_code: "CZ",
            region_name: "10",
            city_name: "Prague",
            postal_code: "11000",
            latitude: nil,
            longitude: nil
          )
        when "103.251.65.149"
          GeoIp::Result.new(
            country_name: "Australia",
            country_code: "AU",
            region_name: "NSW",
            city_name: "Sydney",
            postal_code: "2000",
            latitude: nil,
            longitude: nil
          )
        else
          nil
        end
      end
    end
  end
end
