module Broadcastic

	class NilClassChannel

		def self.channels(resource, to)
		  Array(Channel[resource.to_broadcastic_channel_name])
		end

	end

end