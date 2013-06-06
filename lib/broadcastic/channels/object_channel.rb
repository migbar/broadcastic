module Broadcastic
	class ObjectChannel

    def self.channels(resource, recipient_object)
      Array(Channel[recipient_object.to_broadcastic_channel_name])
    end

	end
end