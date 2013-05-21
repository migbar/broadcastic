begin
  require 'bundler/setup'
rescue LoadError
  puts 'although not required, it is recommended that you use bundler when running the tests'
end

require 'ostruct'
require 'rspec'
require 'active_record'
require 'logger'

require_relative '../lib/broadcastic'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

ActiveRecord::Schema.define do
  self.verbose = false
  create_table :products, :force => true do |t|
    t.string :name
  end
end

class Rails
  def self.logger
    Logger.new(STDOUT)
  end
end

def undefine_product_class
  Object.send(:remove_const, :Product) if defined? Product
end

RSpec.configure do |config|

  config.before(:each) do
    undefine_product_class
    class Product < ActiveRecord::Base; end
  end

end
