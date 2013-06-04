module Broadcastic

	class SymbolChannel

	  def self.channels(resource, to)
    	ChannelResolver.channels_for resource, to: resource.send(to)
	  end

	end

end