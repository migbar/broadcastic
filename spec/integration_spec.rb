require 'spec_helper'
describe "Broadcastic" do

	context "Running on a non-evented server" do
		it "broadcasts through the service when a record is created" do

			undefine_product_class

		  class Product < ActiveRecord::Base
				broadcast :creations, to: :recipients
				def recipients
					["some_url/123", "other_url/456"]
				end

				def id; 1; end

			end

			Pusher.should_receive(:trigger).with(["some_url.123", "other_url.456"],
				"productCreated",
				"{\"name\":\"productCreated\",\"event\":\"created\",\"resource_type\":\"Product\",\"resource\":{\"product\":{\"id\":1,\"name\":\"foo\"}}}")

			Product.create(name: "foo")

		end

		it "broadcasts through the service when a record is updated" do

			undefine_product_class

		  class Product < ActiveRecord::Base
				broadcast :updates, to: :recipients
				def recipients
					["some_url/123", "other_url/456"]
				end

				def id; 1; end

			end

			Pusher.should_receive(:trigger).with(["some_url.123", "other_url.456"],
				"productUpdated",
				"{\"name\":\"productUpdated\",\"event\":\"updated\",\"resource_type\":\"Product\",\"resource\":{\"product\":{\"id\":1,\"name\":\"bar\"}}}")

			Product.create(name: "foo").update_attributes(name: "bar")

		end

		it "broadcasts through the service when a record is destroyed" do

			undefine_product_class

		  class Product < ActiveRecord::Base
				broadcast :destroys, to: :recipients
				def recipients
					["some_url/123", "other_url/456"]
				end

				def id; 1; end

			end

			Pusher.should_receive(:trigger).with(["some_url.123", "other_url.456"],
				"productDestroyed",
				"{\"name\":\"productDestroyed\",\"event\":\"destroyed\",\"resource_type\":\"Product\",\"resource\":{\"product\":{\"id\":1,\"name\":\"foo\"}}}")

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
					["some_url/123", "other_url/456"]
				end

				def id; 1; end
			end

			Pusher.should_receive(:trigger_async).with(["some_url.123", "other_url.456"],
				"productCreated",
				"{\"name\":\"productCreated\",\"event\":\"created\",\"resource_type\":\"Product\",\"resource\":{\"product\":{\"id\":1,\"name\":\"foo\"}}}").and_return(stub.as_null_object)

			Product.create(name: "foo")

		end

		it "broadcasts through the service when a record is updated" do

			undefine_product_class

		  class Product < ActiveRecord::Base
				broadcast :updates, to: :recipients
				def recipients
					["some_url/123", "other_url/456"]
				end

				def id; 1; end

			end

			Pusher.should_receive(:trigger_async).with(["some_url.123", "other_url.456"],
				"productUpdated",
				"{\"name\":\"productUpdated\",\"event\":\"updated\",\"resource_type\":\"Product\",\"resource\":{\"product\":{\"id\":1,\"name\":\"bar\"}}}").and_return(stub.as_null_object)

			Product.create(name: "foo").update_attributes(name: "bar")

		end

		it "broadcasts through the service when a record is destroyed" do

			undefine_product_class

		  class Product < ActiveRecord::Base
				broadcast :destroys, to: :recipients
				def recipients
					["some_url/123", "other_url/456"]
				end

				def id; 1; end

			end

			Pusher.should_receive(:trigger_async).with(["some_url.123", "other_url.456"],
				"productDestroyed",
				"{\"name\":\"productDestroyed\",\"event\":\"destroyed\",\"resource_type\":\"Product\",\"resource\":{\"product\":{\"id\":1,\"name\":\"foo\"}}}").and_return(stub.as_null_object)

			Product.create(name: "foo").destroy

		end

	end
end
