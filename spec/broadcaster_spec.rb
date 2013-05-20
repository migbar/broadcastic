require 'spec_helper'

module Broadcastic
	describe Broadcaster do

		let(:event1) { stub }
		let(:event2) { stub }

		describe ".broadcast" do

			context "with mutliple events" do
				it "should call broadcast_event with each of the events passed in" do
					Broadcaster.should_receive(:broadcast_event).with(event1).once
					Broadcaster.should_receive(:broadcast_event).with(event2).once
					Broadcaster.broadcast([event1, event2])
				end
			end

			context "with a single event" do
				it "should call broadcast_event with the single event passed in" do
					Broadcaster.should_receive(:broadcast_event).with(event1).once
					Broadcaster.broadcast(event1)
				end
			end
		end


		describe ".broadcast_event" do

			it "should delegate the broadcast to Pusher" do
				event1.stub(pusher_channel_name: "some_pusher_channel")
				event1.stub(pusher_event_name: "some_event_nanme")
				event1.stub(to_json: "some_json_string")
				pusher_instance = stub
				Pusher.should_receive(:trigger_async).with(["some_pusher_channel"], "some_event_nanme", "some_json_string").and_return(pusher_instance)
				pusher_instance.should_receive(:callback).and_return(pusher_instance)
				pusher_instance.should_receive(:errback)

				Broadcaster.broadcast_event(event1)
			end


		end


	end

end