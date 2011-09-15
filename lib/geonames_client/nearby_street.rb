module GeonamesClient
  class NearbyStreet

    attr_reader :name

    def initialize( options )
      @name = options[:name]
    end

    def self.all( *names )
      names.map { |name| NearbyStreet.new( :name => name ) }
    end

    def ==( another_nearby_street )
      return false unless another_nearby_street.is_a?( NearbyStreet )
      return false unless another_nearby_street.name == name

      true
    end

    def <=>( another_nearby_street )
      return -1 if name < another_nearby_street.name
      return  1 if name > another_nearby_street.name

      0
    end

  end
end
