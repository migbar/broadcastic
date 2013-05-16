module Broadcastic
  class Broadcaster
  	def self.broadcast(events)
  		puts "********* FIRING *********"
  		Array(events).map(&:fire!)
  		puts "****** FIRING DONE *******"
  	end
  end
end