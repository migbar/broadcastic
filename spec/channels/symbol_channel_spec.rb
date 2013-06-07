require 'spec_helper'

module Broadcastic

	describe SymbolChannel do

		it "evaluates that symbol on the resource given" do
			resource = stub.as_null_object
			resource.should_receive(:admins)
			SymbolChannel.channels_for(resource, :admins)
		end

		it "returns an array with the channels for each of the objects resulting from the evaluation" do
			resource = stub(admins: ["/admins/123", "/admins/345"])
			SymbolChannel.channels_for(resource, :admins).should == [ Channel["/admins/123"], Channel["/admins/345"] ]
		end

	end

end