module Broadcastic
  class Broadcaster
    class << self

      ASYNC = "async"
      SYNC  = "sync"

    	def broadcast(events)
    		Array(events).each do |event|
    			broadcast_event event
    		end
    	end

      # private
    	def broadcast_event(event)
        inside_em_loop? ? async_broadcast(event) : sync_broadcast(event)
    	end

      def inside_em_loop?
        !!(defined?(EventMachine) && EventMachine.reactor_running?)
      end

      def sync_broadcast(event)
        begin
          Pusher.trigger([event.pusher_channel_name], event.pusher_event_name, event.to_json)
          succeeded(SYNC, event)
        rescue Exception => error
          failed(SYNC, event, error)
        end
      end

      def async_broadcast(event)
        Pusher.trigger_async([event.pusher_channel_name], event.pusher_event_name, event.to_json).
          callback { succeeded(ASYNC, event) }.
          errback  { |error| failed(ASYNC, event, error) }
      end

    	def succeeded(mode, event)
    		Logger.debug "."*25
    		Logger.debug "#{mode} - PUSHED: event_name: '#{event.resource_type}.#{event.type}' to channel: '#{event.pusher_channel_name}'"
    		Logger.debug event.to_json
    		Logger.debug "."*25
    	end

    	def failed(mode, event, error)
  			# error is a instance of Pusher::Error
  			Logger.error "#{mode} - ERROR #{error.inspect} while triggering to pusher: \n #{event}"
        raise error
    	end

    end
  end
end