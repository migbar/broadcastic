module Broadcastic
	class Event
    attr_reader :channel
    attr_reader :type
    attr_reader :resource
    attr_reader :resource_type

    def initialize(event_hash)
      @type = event_hash[:event].to_sym
      @channel = event_hash[:channel]

      set_resource_from(event_hash)
    end

    def fire!
    	puts "FIRING EVENT --> #{self.to_json}"
    end

    def as_json
      {
        event:         type,
        resource_type: resource_type,
        resource:      resource.as_json,
        channel:       channel.name
      }
    end

    def to_json
      ActiveSupport::JSON.encode(as_json)
    end

    private

    def fetch(resource_type_name, attributes)
      attributes.symbolize_keys!
      resource_class = Kernel.const_get(resource_type_name)

      return attributes unless resource_class < ActiveRecord::Base

      resource = resource_class.new

      filtered_attributes = attributes.delete_if { |k,v| !resource.has_attribute?(k) }

      resource.assign_attributes(filtered_attributes, :without_protection => true)
      resource
    end

    def set_resource_from(event_hash)
      if Hash === event_hash[:resource]
        @resource = fetch(event_hash[:resource_type], event_hash[:resource])
      else
        @resource = event_hash[:resource]
      end

      @resource_type = event_hash[:resource_type] || resource.class.name
    end

	end
end