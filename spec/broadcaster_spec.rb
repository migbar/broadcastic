require 'spec_helper'

module Broadcastic
	describe Broadcaster do

		let(:event1) { stub.as_null_object }
		let(:event2) { stub.as_null_object }

		describe ".broadcast" do

			context "with mutliple events" do
				it "calls broadcast_event with each of the events passed in" do
					Broadcaster.should_receive(:broadcast_event).with(event1).once
					Broadcaster.should_receive(:broadcast_event).with(event2).once
					Broadcaster.broadcast([event1, event2])
				end
			end

			context "with a single event" do
				it "calls broadcast_event with the single event passed in" do
					Broadcaster.should_receive(:broadcast_event).with(event1).once
					Broadcaster.broadcast([event1])
				end
			end
		end


		describe ".broadcast_event" do


			context "when running as evented" do
				before(:each) do
					Broadcaster.stub(inside_em_loop?: true)
				end

				it "asynchronously delegates the broadcast to Pusher" do
					pusher_instance = stub
					Pusher.should_receive(:trigger_async).and_return(pusher_instance.as_null_object)

					Broadcaster.broadcast_event(event1)
				end

				it "passes the channel name, event name and json to pusher" do
					event1.should_receive(:pusher_channel_name).and_return "some_pusher_channel"
					event1.should_receive(:pusher_event_name).and_return "some_event_name"
					event1.should_receive(:to_json).and_return"some_json_string"
					pusher_instance = stub

					Pusher.should_receive(:trigger_async).with(["some_pusher_channel"], "some_event_name", "some_json_string").and_return(pusher_instance.as_null_object)

					Broadcaster.broadcast_event(event1)
				end
			end

			context "when not running as evented" do
				before(:each) do
					Broadcaster.stub(inside_em_loop?: false)
				end

				it "synchronously delegates the broadcast to Pusher" do
					pusher_instance = stub
					Pusher.should_receive(:trigger).and_return(pusher_instance.as_null_object)

					Broadcaster.broadcast_event(event1)
				end

				it "passes the channel name, event name and json to pusher" do
					event1.should_receive(:pusher_channel_name).and_return "some_pusher_channel"
					event1.should_receive(:pusher_event_name).and_return "some_event_name"
					event1.should_receive(:to_json).and_return"some_json_string"
					pusher_instance = stub

					Pusher.should_receive(:trigger).with(["some_pusher_channel"], "some_event_name", "some_json_string").and_return(pusher_instance.as_null_object)

					Broadcaster.broadcast_event(event1)
				end
			end

		end


	end

end