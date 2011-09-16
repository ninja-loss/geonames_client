require 'spec_helper'

describe GeonamesClient::Service do

  let :service do
    described_class.new( 'test' )
  end

  it "should include the HTTParty module" do
    described_class.included_modules.should include( HTTParty )
  end

  it "should have a service definition" do
    service.service_definition.is_a?( GeonamesClient::ServiceDefinition ).should be_true
  end

  context '#initialize' do

    context "accepting an api_key" do

      subject { described_class.new( 'test' ).api_key }

      it { should == 'test' }

    end

  end

  context '#get_nearby_streets' do

    before :each do
      service.stub!( :nearby_streets ).and_return street_names
    end

    let :http_party_response do
      base = File.join( File.dirname(__FILE__), "..", "..", "data" )

      HTTParty::Response.new YAML::load_file( File.join( base, "geoname_response-headers.yml" ) ),
                             YAML::load_file( File.join( base, "geoname_response-response.yml" ) ),
                             YAML::load_file( File.join( base, "geoname_response-parsed_response.yml" ) )
    end

    let :street_names do
      ["Detering St", "Memorial Dr", "Aloe St", "Hohl St"]
    end

    subject do
      service.get_nearby_streets( :latitude  => '29.762242',
                                  :longitude => '-95.416166' )
    end

    it { should == GeonamesClient::NearbyStreet.all( 'Aloe St',
                                                     'Detering St',
                                                     'Hohl St',
                                                     'Memorial Dr' ) }

  end

  # context '#nearby_streets_from_geonames_northeast' do
  #
  #   subject do
  #     service.nearby_streets_from_geonames_northeast( :latitude  => '29.762242',
  #                                                     :longitude => '-95.416166' )
  #   end
  #
  #   it { should == nil }
  #
  # end

end
