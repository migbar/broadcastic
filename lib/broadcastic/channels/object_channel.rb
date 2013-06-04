module Broadcastic
	class ObjectChannel

    def self.channels(resource, to)
      Array(Channel[to.to_broadcastic_channel_name])
    end

	end
end