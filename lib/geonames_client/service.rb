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

      NearbyStreet.all *nearby_streets( options ).sort
    end

    def get_nearby_streets_within_radius( options )
      options.merge!( :username => api_key )

      street_names = (nearby_streets( options ) +
                      nearby_streets_northeast( options ) +
                      nearby_streets_northwest( options ) +
                      nearby_streets_southeast( options ) +
                      nearby_streets_southwest( options ) ).uniq


      NearbyStreet.all *street_names.sort
    end

    def nearby_streets( options )
      uri = service_definition.full_nearby_streets_uri( options )

      response = self.class.get( uri )

      check_response_for_error( response )

      response.parsed_response['geonames']['streetSegment'].map { |s| s['name'] }.uniq.compact
    end

    def check_response_for_error( response )
      geonames = response['geonames']
      return unless geonames
      error = geonames['status']

      unless error.nil?
        raise "Geonames returned error: (#{error['value']}) #{error['message']}"
      end
    end

    %w(
      northeast
      northwest
      southwest
      southeast
    ).each do |direction|

      define_method "nearby_streets_#{direction}" do |options|
        location = bounding_box( options )[direction.to_sym]
        lat      = location.first
        long     = location.last

        uri = service_definition.full_nearby_streets_uri( :latitude  => lat,
                                                          :longitude => long,
                                                          :username  => api_key )

        response = self.class.get( uri )

        check_response_for_error( response )
        geonames = response.parsed_response['geonames']
        geonames.nil? ? [] : response.parsed_response['geonames']['streetSegment'].map { |s| s['name'] }.uniq.compact
      end

    end

    def bounding_box( options )
      location = Location.new( options[:latitude].to_f,
                               options[:longitude].to_f )

      location.bounding_box_locations_as_hash( options[:radius] || default_radius )
    end

    def default_radius
      402
    end

  end
end
