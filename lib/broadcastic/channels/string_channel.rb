module Broadcastic

	class StringChannel < Channel

		def self.channels_for(resource, to)
	    Array(self[to])
		end

	end

end