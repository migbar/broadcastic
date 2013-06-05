module Broadcastic

  module Broadcast

    def broadcast(*args)
      destination = remove_destination(args)
      args.each { |callback_type| Callbacks.send("broadcast_#{callback_type}", self, destination) }
    end

    def remove_destination(args)
      destination = args.last
      Hash === destination ? args.delete(destination) : {}
    end

    def to_broadcastic_channel_name
      "/#{self.name.pluralize.underscore}"
    end

  end

end
