module Broadcastic

	class SymbolChannel < Channel

	  def self.channels_for(resource, to)
    	ChannelResolver.channels_for resource, to: resource.send(to)
	  end

	end

end