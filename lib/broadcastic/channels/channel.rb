module Broadcastic
  class Channel
    attr_reader :name

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