module Broadcastic

	class ArrayChannel

		def self.channels(resource, to)
			to.map do |destination|
				ChannelResolver.channels_for resource, to: destination
			end.flatten
		end

	end

end