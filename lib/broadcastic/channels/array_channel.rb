module Broadcastic

	class ArrayChannel

		def self.channels(resource, to)
			to.map { |destination| ChannelResolver.channels_for resource, to: destination }.flatten
		end

	end

end