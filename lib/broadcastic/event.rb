module Broadcastic
	class Event
    attr_reader :channels
    attr_reader :type
    attr_reader :resource

    def self.created(resource, options = {})
      new(:created, resource, options)
    end

    def self.updated(resource, options = {})
      new(:updated, resource, options)
    end

    def self.destroyed(resource, options = {})
      new(:destroyed, resource, options)
    end

    def initialize(type, resource, options)
      @type      = type
      @resource  = resource
      @channels  = resolve_channels(resource, options)
    end

    def resolve_channels(resource, options)
      ChannelResolver.channels_for resource, options
    end

    def resource_type
      resource.class.name
    end

    def channel_names
      channels.map(&:name)
    end

    def pusher_channel_names
      channel_names.map { |name| name.gsub(/\//, ".") }
    end

    def name
      uncapitalize "#{resource_type}#{type.capitalize}".camelize
    end

    def uncapitalize(name)
      name[0, 1].downcase + name[1..-1]
    end

    def to_json
      ActiveSupport::JSON.encode(as_json)
    end

    def as_json
      {
        name:           name,
        event:          type,
        resource_type:  resource_type,
        resource:       resource.as_json,
      }
    end

	end
end