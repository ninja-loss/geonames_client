require 'spec_helper'

describe GeonamesClient::Location do

  let :location do
    described_class.new( 41.889118, -87.632146 )
  end

  context '#initialize' do

    it "should accept and set #latitude_in_decimal_degrees" do
      location.latitude_in_decimal_degrees.should == 41.889118
    end

    it "should accept and set #longitude_in_decimal_degrees" do
      location.longitude_in_decimal_degrees.should == -87.632146
    end

  end

  {
    :northeast_theta => 45,
    :northwest_theta => 135,
    :southwest_theta => 225,
    :southeast_theta => 315
  }.each do |name, value|

    context "##{name}" do

      subject { location.send( name ) }

      it { should == value }

    end

  end

  {
    :dx_northeast =>  353.55,
    :dx_northwest => -353.55,
    :dx_southwest => -353.55,
    :dx_southeast =>  353.55
  }.each do |name, value|

    context "##{name}" do

      subject { location.send( name, 500 ) }

      it { should == value }

    end

  end

  {
    :dy_northeast =>  353.55,
    :dy_northwest =>  353.55,
    :dy_southwest => -353.55,
    :dy_southeast => -353.55
  }.each do |name, value|

    context "##{name}" do

      subject { location.send( name, 500 ) }

      it { should == value }

    end

  end

  {
    :delta_latitude_northeast =>  0.003198,
    :delta_latitude_northwest =>  0.003198,
    :delta_latitude_southwest => -0.003198,
    :delta_latitude_southeast => -0.003198
  }.each do |name, value|

    context "##{name}" do

      subject { location.send( name, 500 ) }

      it { should == value }

    end

  end

  {
    :delta_longitude_northeast =>  0.004266,
    :delta_longitude_northwest => -0.004266,
    :delta_longitude_southwest => -0.004266,
    :delta_longitude_southeast =>  0.004266
  }.each do |name, value|

    context "##{name}" do

      subject { location.send( name, 500 ) }

      it { should == value }

    end

  end

  {
    :latitude_northeast =>  41.892316,
    :latitude_northwest =>  41.892316,
    :latitude_southwest =>  41.88592,
    :latitude_southeast =>  41.88592
  }.each do |name, value|

    context "##{name}" do

      subject { location.send( name, 500 ) }

      it { should == value }

    end

  end

  {
    :longitude_northeast => -87.62788,
    :longitude_northwest => -87.636412,
    :longitude_southwest => -87.636412,
    :longitude_southeast => -87.62788
  }.each do |name, value|

    context "##{name}" do

      subject { location.send( name, 500 ) }

      it { should == value }

    end

  end

  {
    :bounding_box_northeast_location => GeonamesClient::Location.new( 41.892316, -87.62788 ),
    :bounding_box_northwest_location => GeonamesClient::Location.new( 41.892316, -87.636412 ),
    :bounding_box_southwest_location => GeonamesClient::Location.new( 41.88592,  -87.636412 ),
    :bounding_box_southeast_location => GeonamesClient::Location.new( 41.88592,  -87.62788 )
  }.each do |name, value|

    context "##{name}" do

      subject { location.send( name, 500 ) }

      it { should == value }

    end

  end

  context "#bounding_box_locations" do

    subject { location.bounding_box_locations( 500 ) }

    it { should == [
                     GeonamesClient::Location.new( 41.892316, -87.62788 ),
                     GeonamesClient::Location.new( 41.892316, -87.636412 ),
                     GeonamesClient::Location.new( 41.88592,  -87.636412 ),
                     GeonamesClient::Location.new( 41.88592,  -87.62788 )
                   ]
       }

  end

  context '#bounding_box_locations_as_array' do

    subject { location.bounding_box_locations_as_array( 500 ) }

    it { should == [
                     [41.892316, -87.62788],
                     [41.892316, -87.636412],
                     [41.88592,  -87.636412],
                     [41.88592,  -87.62788]
                   ]
       }

  end

  context '#bounding_box_locations_as_hash_like_array' do

    subject { location.bounding_box_locations_as_hash_like_array( 500 ) }

    it { should == [
                     [:northeast, [41.892316, -87.62788]],
                     [:northwest, [41.892316, -87.636412]],
                     [:southwest, [41.88592,  -87.636412]],
                     [:southeast, [41.88592,  -87.62788]]
                   ]
       }

  end

  context '#bounding_box_locations_as_hash' do

    subject { location.bounding_box_locations_as_hash( 500 ) }

    it { should == {
                     :northeast => [41.892316, -87.62788],
                     :northwest => [41.892316, -87.636412],
                     :southwest => [41.88592,  -87.636412],
                     :southeast => [41.88592,  -87.62788]
                   }
       }

  end

  context '#to_a' do

    subject { location.to_a }

    it { should == [41.889118, -87.632146] }

  end

end
