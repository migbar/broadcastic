require 'spec_helper'

describe Broadcastic::Event do

	context	"Event creation" do
		it "should create events for a creation" do

			undefine_product_class
			class Product < ActiveRecord::Base
				broadcast :creations
			end
			foo = Product.create(name: "foo")

			events = Broadcastic::Event.created(foo, {})

			expected = {
				event: events.first.type.to_s,
				resource_type: Product.name,
				resource: foo,
				channel: "/products/#{foo.id}"
			}

			events.first.to_json.should == ActiveSupport::JSON.encode(expected)
		end
	end
end