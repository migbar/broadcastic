module Broadcastic

	class SymbolChannel < Channel

	  def self.channels_for(resource, symbol)
    	ChannelResolver.channels_for resource, to: resource.send(symbol)
	  end

	end

end