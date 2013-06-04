require 'spec_helper'

module Broadcastic
	describe StringChannel do
		it "wraps that string into a channel name" do
			string = "/foobar/123"
			StringChannel.channels(stub, string).should == [ Channel[string] ]
		end
	end
end