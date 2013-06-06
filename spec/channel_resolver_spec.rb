require 'spec_helper'

module Broadcastic
	describe ChannelResolver do

		it "gets the channels from the String channel if the destination type is a string" do
			StringChannel.should_receive(:channels)
			ChannelResolver.channels_for(stub, {to: "some_string"})
		end

		it "gets the channels from the Symbol channel if the destination type is a symbol" do
			SymbolChannel.should_receive(:channels)
			ChannelResolver.channels_for(stub, {to: :some_symbol})
		end

		it "gets the channels from the Array channel if the destination type is a array" do
			ArrayChannel.should_receive(:channels)
			ChannelResolver.channels_for(stub, {to: [:some_symbol]})
		end

		it "gets the channels from the NilClass channel if the destination type is empty" do
			NilClassChannel.should_receive(:channels)
			ChannelResolver.channels_for(stub, {})
		end

		it "gets the channels from the Object channel if the destination type is a plain object" do
			some_object = stub
			ObjectChannel.should_receive(:channels)
			ChannelResolver.channels_for(stub, {to: some_object})
		end

		it "gets the channels from excuting the lambda if the destination type is a lambda" do
			channels = ChannelResolver.channels_for(stub, {to: lambda{ 3 + 7 } })
			expect(channels).to eq [ Channel["10"] ]
		end

	end
end