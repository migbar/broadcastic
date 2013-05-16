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

    def to_json
      ActiveSupport::JSON.encode(as_json)
    end

    def as_json
      {
        event:         type,
        resource_type: resource.class.name,
        resource:      resource.as_json,
        channel:       channel.name
      }
    end

	end
end