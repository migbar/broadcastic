require 'spec_helper'


	describe Broadcastic::Event do

		context	"Event creation with no options" do

			it "creates creation events" do
				foo = Product.new(name: "foo")

				events = Broadcastic::Event.created(foo, {})
				event_json = JSON.parse(events.first.to_json)

				expect(events.size).to eq 1
				expect(event_json['resource_type']).to eq "Product"
				expect(event_json['event']).to eq "created"
				expect(event_json['name']).to eq "Product.created"
				expect(event_json['resource']).to eq foo.as_json
				expect(event_json['channel']).to eq "/products/#{foo.id}"
				expect(event_json['pusher_channel']).to eq ".products.#{foo.id}"
			end

			it "creates update events" do
				foo = Product.new(name: "foo")

				events = Broadcastic::Event.updated(foo, {})
				event_json = JSON.parse(events.first.to_json)

				expect(events.size).to eq 1
				expect(event_json['resource_type']).to eq "Product"
				expect(event_json['event']).to eq "updated"
				expect(event_json['name']).to eq "Product.updated"
				expect(event_json['resource']).to eq foo.as_json
				expect(event_json['channel']).to eq "/products/#{foo.id}"
				expect(event_json['pusher_channel']).to eq ".products.#{foo.id}"
			end

			it "creates destroyed events" do
				foo = Product.new(name: "foo")

				events = Broadcastic::Event.destroyed(foo, {})
				event_json = JSON.parse(events.first.to_json)

				expect(events.size).to eq 1
				expect(event_json['resource_type']).to eq "Product"
				expect(event_json['event']).to eq "destroyed"
				expect(event_json['name']).to eq "Product.destroyed"
				expect(event_json['resource']).to eq foo.as_json
				expect(event_json['channel']).to eq "/products/#{foo.id}"
				expect(event_json['pusher_channel']).to eq ".products.#{foo.id}"
			end

		end

		context	"Event creation with one recipient as a :to option" do
			it "creates creation events" do
				foo = Product.new(name: "foo")
				foo.stub(recipients: ["/some_path/123"])
				events = Broadcastic::Event.created(foo, {to: :recipients})
				event_json = JSON.parse(events.first.to_json)

				expect(events.size).to eq 1
				expect(event_json['resource_type']).to eq "Product"
				expect(event_json['event']).to eq "created"
				expect(event_json['name']).to eq "Product.created"
				expect(event_json['resource']).to eq foo.as_json
				expect(event_json['channel']).to eq "/some_path/123"
				expect(event_json['pusher_channel']).to eq ".some_path.123"
			end

		end

		context	"Event creation with multiple recipients as a :to option" do
			it "creates creation events" do
				foo = Product.new(name: "foo")
				foo.stub(recipients: ["/some_path/123", "/other_path/345"])
				events = Broadcastic::Event.created(foo, {to: :recipients})

				expect(events.size).to eq 2

				first_event_json = JSON.parse(events.first.to_json)

				expect(first_event_json['resource_type']).to eq "Product"
				expect(first_event_json['event']).to eq "created"
				expect(first_event_json['name']).to eq "Product.created"
				expect(first_event_json['resource']).to eq foo.as_json
				expect(first_event_json['channel']).to eq "/some_path/123"
				expect(first_event_json['pusher_channel']).to eq ".some_path.123"


				second_event_json = JSON.parse(events.last.to_json)

				expect(events.size).to eq 2
				expect(second_event_json['resource_type']).to eq "Product"
				expect(second_event_json['event']).to eq "created"
				expect(second_event_json['name']).to eq "Product.created"
				expect(second_event_json['resource']).to eq foo.as_json
				expect(second_event_json['channel']).to eq "/other_path/345"
				expect(second_event_json['pusher_channel']).to eq ".other_path.345"

			end

		end
	end
