module Broadcastic

	class StringChannel < Channel

		def self.channels_for(resource, string)
	    Array(self[string])
		end

	end

end