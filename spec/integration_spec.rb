require 'spec_helper'
describe Broadcastic do

	context "Using default configuration" do

		it "delegates the broadcast to the PusherService" do
			undefine_product_class

		  class Product < ActiveRecord::Base
				broadcast :creations
			end

			Broadcastic::PusherService.should_receive(:broadcast)

			Product.create(name: "foo")
		end

	end

	context "Configured to use the stubbed service" do

		it "delegates the broadcast to the StubService" do
			undefine_product_class
			Broadcastic.stub(service: Broadcastic::StubService)

		  class Product < ActiveRecord::Base
				broadcast :creations
			end

			Broadcastic::StubService.should_receive(:broadcast)

			Product.create(name: "foo")
		end

	end

end
