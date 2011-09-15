module GeonamesClient
  class ServiceDefinition

    def self.address
      'api.geonames.org'
    end

    def base_uri
      ['http://', self.class.address].join
    end

    def nearby_streets_path
      '/findNearbyStreets'
    end

    def nearby_streets_json_path
      '/findNearbyStreetsJSON'
    end

    def latitude_parameter
      'lat'
    end

    def longitude_parameter
      'lng'
    end

    def username_parameter
      'username'
    end

    def nearby_streets_base_path( format=:xml )
      format = format.to_sym

      raise "Invalid format: expected one of #{available_formats.join( ', ' )}" unless available_formats.include?( format )

      return [base_uri,
              format == :xml ? nearby_streets_path : nearby_streets_json_path].join ''
    end

    def full_nearby_streets_uri( params={} )
      expected_parameters.each do |p|
        raise "Please provide the :#{p} parameter" unless params.has_key?( p.to_sym )
      end

      format = params.delete( :format ) || default_format

      [nearby_streets_base_path( format ), query_string( params )].join '?'
    end

  private

    def default_format
      :xml
    end

    def available_formats
      [:xml, :json]
    end

    def expected_parameters
      %w(
        latitude
        longitude
        username
      )
    end

    def query_string( params )
      expected_parameters.map do |p|
        [send( "#{p}_parameter" ), params[p.to_sym]].join '='
      end.join '&'
    end

  end
end
