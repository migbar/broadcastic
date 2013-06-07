module Broadcastic
  class ChannelResolver

    def self.channels_for(resource, options)
      destination = options[:to]
      channel_class(destination.class).channels_for(resource, destination)
    end

    def self.channel_class(destination_class)
      begin
        "Broadcastic::#{destination_class.name.gsub(/::/, "")}Channel".constantize
      rescue NameError
        channel_class(destination_class.superclass)
      end
    end

  end
end