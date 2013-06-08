module Broadcastic
  module Callbacks
    extend self

    def broadcast_changes(klass, options)
      broadcast_creations(klass, options)
      broadcast_updates(klass, options)
      broadcast_destroys(klass, options)
    end

    def broadcast_creations(klass, options)
      broadcaster = broadcastic_service
      klass.class_eval do
        after_create { |record| broadcaster.broadcast Event.created(record, options) }
      end
    end

    def broadcast_updates(klass, options)
      broadcaster = broadcastic_service
      klass.class_eval do
        after_update { |record| broadcaster.broadcast Event.updated(record, options) }
      end
    end

    def broadcast_destroys(klass, options)
      broadcaster = broadcastic_service
      klass.class_eval do
        after_destroy { |record| broadcaster.broadcast Event.destroyed(record, options) }
      end
    end

    def broadcastic_service
      Rails.configuration.broadcastic_service || PusherService
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