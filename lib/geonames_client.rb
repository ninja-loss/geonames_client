require "geonames_client/version"

module GeonamesClient
  autoload :NearbyStreet,      'geonames_client/nearby_street'
  autoload :Service,           'geonames_client/service'
  autoload :ServiceDefinition, 'geonames_client/service_definition'
end
