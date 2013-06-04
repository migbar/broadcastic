require 'spec_helper'

module Broadcastic

	describe Channel do
		it "creates an instance with a name" do
			channel = Channel.new("foobar/123")
			channel.should_not be_nil
			channel.name.should == "foobar/123"
		end

		it "memoizes channels by name" do
			channel = stub
			Channel.should_receive(:new).with("foobar/123").and_return(channel)
			first = Channel["foobar/123"]
			first.should == channel
			Channel.should_not_receive(:new)
			second = Channel["foobar/123"]
			second.should == first
		end
	end

end