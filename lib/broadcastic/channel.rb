module Broadcastic
  class Channel
    attr_reader :name

    def self.destinations_for(resource, options)
      to = options[:to]
      case to
      when String then
        Array(Channel[to])
      when Symbol then
        Array(Channel.collect_channels resource.send(to))
      else
        Array(Channel[resource.to_broadcastic_channel_name])
      end
    end

    def self.collect_channels(destinations)
      Array(destinations).map(&:to_broadcastic_channel_name).collect {|name| Channel[name]}
    end

    def self.channels
      @channels ||= {}
    end

    def self.[](name)
      channels[name] ||= Channel.new(name)
    end

    def initialize(name)
      @name = name
    end

  end
end