module Broadcastic
  module ModelCallbacks
    extend self

    def broadcast_changes(klass, options)
      broadcast_creations(klass, options)
      broadcast_updates(klass, options)
      broadcast_destroys(klass, options)
    end

    def broadcast_creations(klass, options)
      klass.class_eval do
        after_create do |record|
          ModelCallbacks.broadcast :created, record, options
        end
      end
    end

    def broadcast_updates(klass, options)
      klass.class_eval do
        after_update do |record|
          ModelCallbacks.broadcast :updated, record, options
        end
      end
    end

    def broadcast_destroys(klass, options)
      klass.class_eval do
        after_destroy do |record|
          ModelCallbacks.broadcast :destroyed, record, options
        end
      end
    end


    def broadcast(type, record, options)
      channel_destinations(record, options).each do |channel|
        Broadcaster.broadcast create_event(type, record, channel)
      end
    end

    private


    def create_event(type, record, channel)
      Event.new(event: type, resource:record, resource_type: record.class.name, channel: channel)
    end

    def channel_destinations(record, options)
      to = options[:to]
      case to
      when String then
        Array(Channel[to])
      when Symbol then
        Array(Channel.for record.send(to))
      else
        Array(Channel.default_for(record))
      end
    end

    def method_missing(method_name, *arguments, &block)
      if method_name.to_s =~ /broadcast_(.*)/
        raise_callback_name_exception $1
      else
        super
      end
    end

    def raise_callback_name_exception(invalid_callback_name)
      raise Broadcastic::InvalidCallbackName,
         "Don't understand #{invalid_callback_name} callback. " +
         "Accepted values are: :changes, :creations, :updates, :destroys"
    end
  end
end