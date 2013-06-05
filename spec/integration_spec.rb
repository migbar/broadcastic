require 'spec_helper'
describe "Broadcastic" do

	context "Running on a non-evented server" do
		it "broadcasts through the service when a record is created" do

			undefine_product_class

		  class Product < ActiveRecord::Base
				broadcast :creations, to: :recipients
				def recipients
					["some_url/123"]
				end

				def id; 1; end

			end

			Pusher.should_receive(:trigger).with(["some_url.123"],
				"productCreated",
				"{\"name\":\"productCreated\",\"pusher_channel\":\"some_url.123\",\"event\":\"created\",\"resource_type\":\"Product\",\"resource\":{\"product\":{\"id\":1,\"name\":\"foo\"}},\"channel\":\"some_url/123\"}")

			Product.create(name: "foo")

		end

		it "broadcasts through the service when a record is updated" do

			undefine_product_class

		  class Product < ActiveRecord::Base
				broadcast :updates, to: :recipients
				def recipients
					["some_url/123"]
				end

				def id; 1; end

			end

			Pusher.should_receive(:trigger).with(["some_url.123"],
				"productUpdated",
				"{\"name\":\"productUpdated\",\"pusher_channel\":\"some_url.123\",\"event\":\"updated\",\"resource_type\":\"Product\",\"resource\":{\"product\":{\"id\":1,\"name\":\"bar\"}},\"channel\":\"some_url/123\"}")

			Product.create(name: "foo").update_attributes(name: "bar")

		end

		it "broadcasts through the service when a record is destroyed" do

			undefine_product_class

		  class Product < ActiveRecord::Base
				broadcast :destroys, to: :recipients
				def recipients
					["some_url/123"]
				end

				def id; 1; end

			end

			Pusher.should_receive(:trigger).with(["some_url.123"],
				"productDestroyed",
				"{\"name\":\"productDestroyed\",\"pusher_channel\":\"some_url.123\",\"event\":\"destroyed\",\"resource_type\":\"Product\",\"resource\":{\"product\":{\"id\":1,\"name\":\"foo\"}},\"channel\":\"some_url/123\"}")

			Product.create(name: "foo").destroy

		end

	end

	context	"Running on an evented server" do

		before(:each) do
			Broadcastic::Broadcaster.stub(inside_em_loop?: true)
		end

		it "broadcasts through the service when a record is created" do

			undefine_product_class

		  class Product < ActiveRecord::Base
				broadcast :creations, to: :recipients
				def recipients
					["some_url/123"]
				end

				def id; 1; end
			end

			Pusher.should_receive(:trigger_async).with(["some_url.123"],
				"productCreated",
				"{\"name\":\"productCreated\",\"pusher_channel\":\"some_url.123\",\"event\":\"created\",\"resource_type\":\"Product\",\"resource\":{\"product\":{\"id\":1,\"name\":\"foo\"}},\"channel\":\"some_url/123\"}").and_return(stub.as_null_object)

			Product.create(name: "foo")

		end

		it "broadcasts through the service when a record is updated" do

			undefine_product_class

		  class Product < ActiveRecord::Base
				broadcast :updates, to: :recipients
				def recipients
					["some_url/123"]
				end

				def id; 1; end

			end

			Pusher.should_receive(:trigger_async).with(["some_url.123"],
				"productUpdated",
				"{\"name\":\"productUpdated\",\"pusher_channel\":\"some_url.123\",\"event\":\"updated\",\"resource_type\":\"Product\",\"resource\":{\"product\":{\"id\":1,\"name\":\"bar\"}},\"channel\":\"some_url/123\"}").and_return(stub.as_null_object)

			Product.create(name: "foo").update_attributes(name: "bar")

		end

		it "broadcasts through the service when a record is destroyed" do

			undefine_product_class

		  class Product < ActiveRecord::Base
				broadcast :destroys, to: :recipients
				def recipients
					["some_url/123"]
				end

				def id; 1; end

			end

			Pusher.should_receive(:trigger_async).with(["some_url.123"],
				"productDestroyed",
				"{\"name\":\"productDestroyed\",\"pusher_channel\":\"some_url.123\",\"event\":\"destroyed\",\"resource_type\":\"Product\",\"resource\":{\"product\":{\"id\":1,\"name\":\"foo\"}},\"channel\":\"some_url/123\"}").and_return(stub.as_null_object)

			Product.create(name: "foo").destroy

		end

	end
end
# <Broadcastic::Event:0x007f82292ede68
# 	@type=:created,
# 	@resource=<Broadcastic::Product id: 1, name: "foo">,
# 	@channel=<Broadcastic::Channel:0x007f82292ee5c0 @name="some_url/123">>

# <Broadcastic::Event:0x007f82292ede18
# 	@type=:created,
# 	@resource=<Broadcastic::Product id: 1, name: "foo">,
# 	@channel=<Broadcastic::Channel:0x007f82292ee188 @name="other_url/12334">>