require 'spec_helper'
module Broadcastic
	describe "Broadcastic" do

		it "Should broadcast when an AR is created" do

			undefine_product_class

		  class Product < ActiveRecord::Base
				broadcast :creations, to: :recipients
				def recipients
					["some_url/123", "other_url/12334"]
				end
			end

			Broadcaster.should_receive(:broadcast)

			Product.create(name: "foo")

		end
	end
end