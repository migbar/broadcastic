require 'pusher'
require_relative 'broadcastic/monkey_patches/active_record.rb'
require_relative 'broadcastic/monkey_patches/object.rb'
require_relative 'broadcastic/broadcast'
require_relative 'broadcastic/broadcaster'
require_relative 'broadcastic/event'
require_relative 'broadcastic/callbacks'
require_relative 'broadcastic/exceptions'
require_relative 'broadcastic/logger'
require_relative 'broadcastic/channels/channel'
require_relative 'broadcastic/channels/channel_resolver'
require_relative 'broadcastic/channels/string_channel'
require_relative 'broadcastic/channels/object_channel'
require_relative 'broadcastic/channels/proc_channel'
require_relative 'broadcastic/channels/array_channel'
require_relative 'broadcastic/channels/symbol_channel'
require_relative 'broadcastic/channels/nil_class_channel'

module Broadcastic
  ActiveRecord::Base.extend Broadcast
end