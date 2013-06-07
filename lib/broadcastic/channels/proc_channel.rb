module Broadcastic
	class ProcChannel < Channel

    def self.channels_for(resource, proc)
      ChannelResolver.channels_for resource, to: proc.call
    end

	end
end