# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'broadcastic/version'

Gem::Specification.new do |s|
  s.name        = "broadcastic"
  s.version     = Broadcastic::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Miguel Barcos"]
  s.email       = ["miguel@galar.com"]
  s.homepage    = "http://github.com/migbar/broadcastic"
  s.summary     = %q{ActiveRecord callback broadcaster over Pusher}
  s.description = %q{Easily broadcast your CRUD callbacks using Pusher's REST api}

  s.add_dependency 'json', '~> 1.7.7'
  s.add_dependency "pusher", "~> 0.11.3"
  s.add_dependency "activerecord", ">= 3.0.0"

  s.add_development_dependency "rspec", "~> 2.0"
  s.add_development_dependency "sqlite3"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end