require 'spec_helper'

module Broadcastic
	describe NilClassChannel do

		it "turns the resource into a channel name" do
			resource = stub(to_broadcastic_channel_name: "some_resource_channel")
			NilClassChannel.channels(resource, nil).should == [ Channel["some_resource_channel"] ]
		end

	end
end