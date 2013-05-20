module Broadcastic
  class Broadcaster
    class << self

    	def broadcast(events)
    		Array(events).each do |event|
    			broadcast_event event
    		end
    	end

      # private
    	def broadcast_event(event)
    		Pusher.trigger_async([event.pusher_channel_name], event.pusher_event_name, event.to_json).
    			callback { succeeded(event) }.
  				errback  { |error| failed(event, error) }
    	end

    	def succeeded(event)
    		puts "."*25
    		puts "PUSHED: event_name: '#{event.resource_type}.#{event.type}' to channel: '#{event.pusher_channel_name}'"
    		puts event.to_json
    		puts "."*25
    	end

    	def failed(event, error)
  			# error is a instance of Pusher::Error
  			puts "ERROR #{error.inspect} while async triggering to pusher: \n #{event}"
    	end

    end
  end
end