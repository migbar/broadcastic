begin
  require 'bundler/setup'
rescue LoadError
  puts 'although not required, it is recommended that you use bundler when running the tests'
end

require 'ostruct'
require 'rspec'
require 'active_record'

require_relative '../lib/broadcastic'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

ActiveRecord::Schema.define do
  self.verbose = false
  create_table :products, :force => true do |t|
    t.string :name
  end
end

def undefine_product_class
  Object.send(:remove_const, :Product) if defined? Product
end

RSpec.configure do |config|
  config.before(:each) do
    #..
  end
end
