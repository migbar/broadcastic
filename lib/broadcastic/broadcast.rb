module Broadcastic
  module Broadcast

    def broadcast(*args)
      destination = get_destination args

      args.each do |callback_type|
        ModelCallbacks.send("broadcast_#{callback_type}", self, destination)
      end
    end

    def get_destination(args)
      destination = args.last
      Hash === destination ? args.delete(destination) : {}
    end
  end
end
