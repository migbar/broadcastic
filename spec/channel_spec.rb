require 'spec_helper'

module Broadcastic

	describe Channel do
		it "should create an instance with a name" do
			channel = Channel.new("foobar/123")
			channel.should_not be_nil
			channel.name.should == "foobar/123"
		end

		it "should memoize channels by name" do
			channel = stub
			Channel.should_receive(:new).with("foobar/123").and_return(channel)
			first = Channel["foobar/123"]
			first.should == channel
			Channel.should_not_receive(:new)
			second = Channel["foobar/123"]
			second.should == first
		end

		describe "#destinations_for" do

			context "given a string as a :to destination" do
				it "should wrap that string into a channel name" do
					resource = stub
					string = "/foobar/123"
					Channel.destinations_for(resource, {to: string}).should == [ Channel[string]]
				end
			end

			context "given a symbol as a :to destination" do
				it "should evaluate that symbol on the resource given" do
					resource = stub
					resource.should_receive(:admins)
					Channel.destinations_for(resource, {to: :admins})
				end

				it "should return an array with the channels for each of the objects resulting from the evaluation" do
					resource = stub
					resource.stub(admins: ["/admins/123", "/admins/345"])
					Channel.destinations_for(resource, {to: :admins}).should == [ Channel["/admins/123"], Channel["/admins/345"] ]
				end
			end

			context "given any other object as a :to destination" do
				it "should turn that object into a channel name" do
					resource = stub
					some_object = stub
					resource.stub(to_broadcastic_channel_name: "some_resource_channel")
					Channel.destinations_for(resource, {to: some_object}).should == [ Channel["some_resource_channel"] ]
				end

			end

		end

	end

end