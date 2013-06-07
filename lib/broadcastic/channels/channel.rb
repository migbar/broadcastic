module Broadcastic
  class Channel
    attr_reader :name

    def self.channels
      @channels ||= {}
    end

    def self.[](name)
      Channel.channels[name] ||= new(name)
    end

    def initialize(name)
      @name = name
    end

  end
end