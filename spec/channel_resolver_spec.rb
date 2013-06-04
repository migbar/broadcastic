require 'spec_helper'

module Broadcastic
	describe ChannelResolver do

		it "gets the channels from the String channel if the destination type is a string" do
			resource = stub
			StringChannel.should_receive(:channels)
			ChannelResolver.channels_for(resource, {to: "some_string"})
		end

		it "gets the channels from the Symbol channel if the destination type is a symbol" do
			resource = stub
			SymbolChannel.should_receive(:channels)
			ChannelResolver.channels_for(resource, {to: :some_symbol})
		end

		it "gets the channels from the Array channel if the destination type is a array" do
			resource = stub
			ArrayChannel.should_receive(:channels)
			ChannelResolver.channels_for(resource, {to: [:some_symbol]})
		end

		it "gets the channels from the NilClass channel if the destination type is empty" do
			resource = stub
			NilClassChannel.should_receive(:channels)
			ChannelResolver.channels_for(resource, {})
		end

		it "gets the channels from the Object channel if the destination type is a plain object" do
			resource = stub
			some_object = stub
			ObjectChannel.should_receive(:channels)
			ChannelResolver.channels_for(resource, {to: some_object})
		end

	end
end