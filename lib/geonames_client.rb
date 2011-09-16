require "geonames_client/version"

module GeonamesClient
  autoload :Location,          'geonames_client/location'
  autoload :NearbyStreet,      'geonames_client/nearby_street'
  autoload :Service,           'geonames_client/service'
  autoload :ServiceDefinition, 'geonames_client/service_definition'
end

class Numeric
  def degrees
    self * Math::PI / 180
  end
end
