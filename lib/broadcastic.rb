require 'pusher'
require_relative 'broadcastic/monkey_patches'
require_relative 'broadcastic/broadcast'
require_relative 'broadcastic/broadcaster'
require_relative 'broadcastic/channel'
require_relative 'broadcastic/event'
require_relative 'broadcastic/callbacks'
require_relative 'broadcastic/exceptions'
require_relative 'broadcastic/logger'

module Broadcastic
  ActiveRecord::Base.extend Broadcast
end