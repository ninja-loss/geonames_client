require 'httparty'

module GeonamesClient
  class Service

    include HTTParty

    base_uri ServiceDefinition.address

    attr_reader :api_key

    def initialize( api_key )
      @api_key = api_key
    end

    def service_definition
      @service_definition ||= ServiceDefinition.new
    end

    def get_nearby_streets( options )
      options.merge!( :username => api_key )

      response = nearby_streets_from_geonames( options )

      error = response['geonames']['status']

      unless error.nil?
        raise "Geonames returned error: (#{error['value']}) #{error['message']}"
      end

      street_names = response.parsed_response['geonames']['streetSegment'].map { |s| s['name'] }.uniq

      NearbyStreet.all *street_names
    end

  private

    def nearby_streets_from_geonames( options )
      uri = service_definition.full_nearby_streets_uri( options )

      self.class.get( uri )
    end

  end
end
