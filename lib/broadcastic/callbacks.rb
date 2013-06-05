module Broadcastic
  module Callbacks
    extend self

    def broadcast_changes(klass, options)
      broadcast_creations(klass, options)
      broadcast_updates(klass, options)
      broadcast_destroys(klass, options)
    end

    def broadcast_creations(klass, options)
      klass.class_eval do
        after_create { |record| Broadcaster.broadcast Event.created(record, options) }
      end
    end

    def broadcast_updates(klass, options)
      klass.class_eval do
        after_update { |record| Broadcaster.broadcast Event.updated(record, options) }
      end
    end

    def broadcast_destroys(klass, options)
      klass.class_eval do
        after_destroy { |record| Broadcaster.broadcast Event.destroyed(record, options) }
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