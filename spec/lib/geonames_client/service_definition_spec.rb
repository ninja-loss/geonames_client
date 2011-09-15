require 'spec_helper'

describe GeonamesClient::ServiceDefinition do

  let :service_definition do
    described_class.new
  end

  context '.address' do

    subject { GeonamesClient::ServiceDefinition.address }

    it { should == 'api.geonames.org' }

  end

  {
    'base_uri'                 => 'http://api.geonames.org',
    'nearby_streets_path'      => '/findNearbyStreets',
    'nearby_streets_json_path' => '/findNearbyStreetsJSON',
    'latitude_parameter'       => 'lat',
    'longitude_parameter'      => 'lng',
    'username_parameter'       => 'username'

  }.each do |method_name, value|

    context "##{method_name}" do

      subject { service_definition.send( method_name ) }

      it { should == value  }

    end

  end

  context '#nearby_streets_base_path' do

    {
      :xml   => 'http://api.geonames.org/findNearbyStreets',
      :json  => 'http://api.geonames.org/findNearbyStreetsJSON',
      'xml'  => 'http://api.geonames.org/findNearbyStreets',
      'json' => 'http://api.geonames.org/findNearbyStreetsJSON'
    }.each do |format, value|

      context "when #{format} requested" do

        subject { service_definition.nearby_streets_base_path( format ) }

        it { should == value  }

      end

    end

    it "should raise an exception when the format is not an avaliable format" do
      lambda { service_definition.nearby_streets_base_path( :html ) }.should(
        raise_error( RuntimeError, /^Invalid format: expected one of .*/ )
      )
    end

  end

  context '#full_nearby_streets_uri' do

    let :params do
      {
        :latitude  => '29.762242',
        :longitude => '-95.416166',
        :username  => 'ncite'
      }
    end

    context 'when given all expected paramaters in a hash' do

      context 'and no format is provided do' do

        subject { service_definition.full_nearby_streets_uri( params ) }

        it { should == 'http://api.geonames.org/findNearbyStreets?lat=29.762242&lng=-95.416166&username=ncite' }

      end

      context 'and a format of :xml is provided do' do

        subject { service_definition.full_nearby_streets_uri( params.merge( :format => :xml ) ) }

        it { should == 'http://api.geonames.org/findNearbyStreets?lat=29.762242&lng=-95.416166&username=ncite' }

      end

      context 'and a format of :json is provided do' do

        subject { service_definition.full_nearby_streets_uri( params.merge( :format => :json ) ) }

        it { should == 'http://api.geonames.org/findNearbyStreetsJSON?lat=29.762242&lng=-95.416166&username=ncite' }

      end

    end

    context 'when not given all of the expected params' do

      %w(
        latitude
        longitude
        username
      ).each do |parameter|

        it "should raise an exception when the #{parameter} parameter is not provided" do
          lambda { service_definition.full_nearby_streets_uri( params.except( parameter.to_sym ) ) }.should(
            raise_error( RuntimeError, "Please provide the :#{parameter} parameter" )
            )
        end

      end

    end

  end

end
