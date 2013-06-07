require 'spec_helper'

module Broadcastic
	describe ArrayChannel do
		it "resolves each item in the array to a channel" do
			resource = stub
			alice = stub
			bob = stub
			destinations = [bob, alice]
			ChannelResolver.should_receive(:channels_for).with(resource, to: bob)
			ChannelResolver.should_receive(:channels_for).with(resource, to: alice)
			ArrayChannel.channels_for(resource, destinations)
		end

		context "given an array of strings as a :to destination" do
			it "uses each string in the array as a channel name" do
				ArrayChannel.channels_for(stub, ["/foo/bar/123", "/bar/baz/456"]).should == [ Channel["/foo/bar/123"], Channel["/bar/baz/456"]]
			end
		end

		context "given an array of objects as a :to destination" do
			it "turns each object in the array to a channel name" do
				alice = stub(to_broadcastic_channel_name: "/alice/123")
				bob = stub(to_broadcastic_channel_name: "/bob/456")
				ArrayChannel.channels_for(stub, [alice, bob]).should == [ Channel["/alice/123"], Channel["/bob/456"]]
			end
		end

		context "given an array of symbols as a :to destination" do
			it "returns an array with the channels for each of the objects resulting from the evaluation" do
				resource = stub
				resource.stub(admins: ["/admins/123"])
				resource.stub(operators: ["/operators/456"])
				ArrayChannel.channels_for(resource, [:admins, :operators]).should == [ Channel["/admins/123"], Channel["/operators/456"] ]
			end
		end

		context "given a mixed array of strings, symbols and object as a :to destination" do
			it "evaluates each symbol on the resource given" do
				operator = stub.as_null_object
				resource = stub.as_null_object
				resource.should_receive(:admins)
				ArrayChannel.channels_for(resource, ["/foo/bar/123", :admins, operator])
			end

			it "turns each object into a channel name" do
				operator = stub
				operator.should_receive(:to_broadcastic_channel_name)
				resource = stub.as_null_object
				resource.should_receive(:admins)
				ArrayChannel.channels_for(resource, ["/foo/bar/123", :admins, operator])
			end

			it "returns an array with the channels for each of the objects resulting from the evaluation" do
				resource = stub
				resource.stub(admins: ["/admins/123"])
				resource.stub(operators: ["/operators/456"])
				ArrayChannel.channels_for(resource, ["/my/channel", :admins, :operators]).should == [ Channel["/my/channel"], Channel["/admins/123"], Channel["/operators/456"] ]
			end
		end

	end
end