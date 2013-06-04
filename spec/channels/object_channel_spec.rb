require 'spec_helper'

module Broadcastic
	describe ObjectChannel do

		it "turns that object into a channel name" do
			any_object = stub(to_broadcastic_channel_name: "some_resource_channel")
			ObjectChannel.channels(stub, any_object).should == [ Channel["some_resource_channel"] ]
		end

	end
end