module Broadcastic
	class Event
    attr_reader :channel
    attr_reader :type
    attr_reader :resource

    def self.created(resource, options = {})
      events(:created, resource, options)
    end

    def self.updated(resource, options = {})
      events(:updated, resource, options)
    end

    def self.destroyed(resource, options = {})
      events(:destroyed, resource, options)
    end

    def self.events(type, resource, options)
      channels(resource, options).map do |channel|
        new(type, resource, channel)
      end
    end

    def self.channels(resource, options)
      Channel.destinations_for resource, options
    end

    def initialize(type, resource, channel)
      @type     = type
      @resource = resource
      @channel  = channel
    end

    def fire!
    	puts self.to_json
    end

    def resource_type
      resource.class.name
    end

    def channel_name
      channel.name
    end

    def pusher_channel_name
      channel.name.gsub(/\//, ".")
    end

    def pusher_event_name
      "#{resource_type}.#{type}"
    end

    def to_json
      ActiveSupport::JSON.encode(as_json)
    end

    def as_json
      {
        name:           pusher_event_name,
        pusher_channel: pusher_channel_name,
        event:          type,
        resource_type:  resource_type,
        resource:       resource.as_json,
        channel:        channel_name
      }
    end

	end
end