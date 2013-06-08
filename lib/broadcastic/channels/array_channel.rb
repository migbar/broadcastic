module Broadcastic

	class ArrayChannel < Channel

		def self.channels_for(resource, destinations)
			destinations.map { |destination| ChannelResolver.channels_for resource, to: destination }.flatten
		end

	end

end