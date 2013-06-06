module Broadcastic
	class ProcChannel

    def self.channels(resource, proc)
      ChannelResolver.channels_for resource, to: proc.call
    end

	end
end