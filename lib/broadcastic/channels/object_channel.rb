module Broadcastic
	class ObjectChannel < Channel

    def self.channels_for(resource, destination_object)
      Array(self[destination_object.to_broadcastic_channel_name])
    end

	end
end