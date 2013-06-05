require 'spec_helper'


	describe Broadcastic::Event do

		context	"Event creation with no options" do

			it "creates creation events" do
				foo = Product.new(name: "foo")

				event = Broadcastic::Event.created(foo, {})

				expect(event.resource_type).to eq "Product"
				expect(event.type).to eq :created
				expect(event.name).to eq "productCreated"
				expect(event.resource.as_json).to eq foo.as_json
				expect(event.channel_names).to eq ["/products/#{foo.id}"]
			end

			it "creates update events" do
				foo = Product.new(name: "foo")

				event = Broadcastic::Event.updated(foo, {})

				expect(event.resource_type).to eq "Product"
				expect(event.type).to eq :updated
				expect(event.name).to eq "productUpdated"
				expect(event.resource.as_json).to eq foo.as_json
				expect(event.channel_names).to eq ["/products/#{foo.id}"]
			end

			it "creates destroyed events" do
				foo = Product.new(name: "foo")

				event = Broadcastic::Event.destroyed(foo, {})

				expect(event.resource_type).to eq "Product"
				expect(event.type).to eq :destroyed
				expect(event.name).to eq "productDestroyed"
				expect(event.resource.as_json).to eq foo.as_json
				expect(event.channel_names).to eq ["/products/#{foo.id}"]
			end

		end

		context	"Event creation with one recipient as a :to option" do

			it "creates creation events" do
				foo = Product.new(name: "foo")
				foo.stub(recipients: ["/some_path/123"])
				event = Broadcastic::Event.created(foo, {to: :recipients})

				expect(event.resource_type).to eq "Product"
				expect(event.type).to eq :created
				expect(event.name).to eq "productCreated"
				expect(event.resource.as_json).to eq foo.as_json
				expect(event.channel_names).to eq ["/some_path/123"]
			end

		end

		context	"Event creation with multiple recipients as a :to option" do

			it "creates creation events" do
				foo = Product.new(name: "foo")
				foo.stub(recipients: ["/some_path/123", "/other_path/345"])
				event = Broadcastic::Event.created(foo, {to: :recipients})

				expect(event.resource_type).to eq "Product"
				expect(event.type).to eq :created
				expect(event.name).to eq "productCreated"
				expect(event.resource.as_json).to eq foo.as_json
				expect(event.channel_names).to eq ["/some_path/123", "/other_path/345"]
			end

		end
	end
