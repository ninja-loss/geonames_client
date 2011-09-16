module GeonamesClient
  # This class is not suitable for distances over a couple of miles.  Due to the fact
  # that spherical triginometry must be employed due to the curvature of the earth.
  #
  class Location

    attr_reader :latitude_in_decimal_degrees, :longitude_in_decimal_degrees

    def initialize( latitude_in_decimal_degrees,
                    longitude_in_decimal_degrees )
      @latitude_in_decimal_degrees  = latitude_in_decimal_degrees
      @longitude_in_decimal_degrees = longitude_in_decimal_degrees
    end

    def bounding_box_locations_as_array( distance )
      bounding_box_locations( distance ).map &:to_a
    end

    def bounding_box_locations_as_hash_like_array( distance )
        [
          :northeast,
          :northwest,
          :southwest,
          :southeast
        ].zip( bounding_box_locations_as_array( distance ) )
    end

    def bounding_box_locations_as_hash( distance )
      hash = {}

      bounding_box_locations_as_hash_like_array( distance ).each do |direction, location|
        hash[direction] = location
      end

      hash
    end

    def bounding_box_locations( distance )
      %w(
        northeast
        northwest
        southwest
        southeast
      ).map do |direction|
        send( "bounding_box_#{direction}_location", distance )
      end
    end

    def to_a
      [
        latitude_in_decimal_degrees,
        longitude_in_decimal_degrees
      ]
    end

    def ==( another_location )
      return false unless another_location.is_a?( Location )
      return false unless another_location.latitude_in_decimal_degrees == latitude_in_decimal_degrees
      return false unless another_location.longitude_in_decimal_degrees == longitude_in_decimal_degrees

      true
    end

  private

    %w(
      northeast
      northwest
      southwest
      southeast
    ).each do |direction|

      define_method "dx_#{direction}" do |distance|
        rount_float( distance * Math.cos( send( "#{direction}_theta" ).degrees ), 2 )
      end

      define_method "dy_#{direction}" do |distance|
        rount_float( distance * Math.sin( send( "#{direction}_theta" ).degrees ), 2 )
      end

      define_method "delta_latitude_#{direction}" do |distance|
        rount_float( send( "dy_#{direction}", distance ) / 110540.0, 6 )
      end

      define_method "delta_longitude_#{direction}" do |distance|
        rount_float( send( "dx_#{direction}", distance ) / (111320.0 * Math.cos( latitude_in_decimal_degrees.degrees )), 6 )
      end

      define_method "latitude_#{direction}" do |distance|
        rount_float( latitude_in_decimal_degrees + send( "delta_latitude_#{direction}", distance ), 6 )
      end

      define_method "longitude_#{direction}" do |distance|
        rount_float( longitude_in_decimal_degrees + send( "delta_longitude_#{direction}", distance ), 6 )
      end

      define_method "bounding_box_#{direction}_location" do |distance|
        Location.new send( "latitude_#{direction}",  distance ),
                     send( "longitude_#{direction}", distance )
      end

    end

    # Measuring theta from due east.
    {
      :northeast => 45,
      :northwest => 135,
      :southwest => 225,
      :southeast => 315
    }.each do |direction, value|

      define_method "#{direction}_theta" do
        value
      end

    end

    def rount_float( val, precision )
      sprintf( "%.#{precision}f", val ).to_f
    end

  end
end
