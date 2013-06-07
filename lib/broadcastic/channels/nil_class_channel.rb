module Broadcastic

	class NilClassChannel < Channel

		def self.channels_for(resource, to)
		  Array(self[resource.to_broadcastic_channel_name])
		end

	end

end