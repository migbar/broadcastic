module Broadcastic
	class ObjectChannel < Channel

    def self.channels_for(resource, recipient_object)
      Array(self[recipient_object.to_broadcastic_channel_name])
    end

	end
end