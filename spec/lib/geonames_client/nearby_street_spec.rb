require 'spec_helper'

describe GeonamesClient::NearbyStreet do

  context '#initialize' do

    context "accepting a name" do

      subject { described_class.new( :name => 'Some St.' ).name }

      it { should == 'Some St.' }

    end

  end

  context '.all' do

    subject { described_class.all( 'Some St.', 'Another St.' ) }

    it { should == [
           GeonamesClient::NearbyStreet.new( :name => 'Some St.' ),
           GeonamesClient::NearbyStreet.new( :name => 'Another St.' )
         ] }

  end

end
