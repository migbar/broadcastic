module Broadcastic

	class NilClassChannel < Channel

		def self.channels_for(resource, nil_destination)
		  Array(self[resource.to_broadcastic_channel_name])
		end

	end

end