module Broadcastic
  class Broadcaster
  	def self.broadcast(event)
  		puts "********* FIRING *********"
  		event.fire!
  		puts "****** FIRING DONE *******"
  	end
  end
end