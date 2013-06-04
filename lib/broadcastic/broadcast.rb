module Broadcastic
  module Broadcast

    module InstanceMethods
      def to_broadcastic_channel_name
        "#{self.class.to_broadcastic_channel_name}/#{id}"
      end
    end

    include InstanceMethods

    def broadcast(*args)
      destination = get_destination args

      args.each do |callback_type|
        Callbacks.send("broadcast_#{callback_type}", self, destination)
      end
    end

    def get_destination(args)
      destination = args.last
      Hash === destination ? args.delete(destination) : {}
    end

    def to_broadcastic_channel_name
      "/#{self.name.pluralize.underscore}"
    end


  end
end
