module Broadcastic
  class Channel
    attr_reader :name

    def self.channels
      @channels ||= {}
    end

    def self.[](name)
      channels[name] ||= Channel.new(name)
    end

    def self.for(records)
      names_for(records).collect { |name| Channel[name] }
    end

    def self.default_for(resource_or_class, type = :member)
      Channel[default_name_for(resource_or_class, type)]
    end

    def self.default_name_for(resource_or_class, type = :member)
      if resource_or_class.kind_of?(Class)
        resource_name = resource_or_class.name.pluralize.underscore
      else
        resource      = resource_or_class
        resource_name = resource.class.name.pluralize.underscore
      end

      case type
      when :member then
        "/#{resource_name}/#{resource.id}"
      when :collection then
        "/#{resource_name}/"
      end
    end

    def initialize(name)
      @name = name
    end

    def self.names_for(records)
      case records
      when String
        Array(records)
      when Enumerable then
        records.collect { |r| default_name_for(r) }
      else
        Array(Channel.default_name_for(records))
      end
    end

  end
end