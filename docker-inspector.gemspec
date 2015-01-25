# -*- encoding: utf-8 -*-
require File.expand_path("../lib/inspector/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "docker-inspector"
  s.version     = Inspector::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Flavio Castelli']
  s.email       = ['flavio@castelli.me']
  s.summary     = "Simple analyzer of Docker images stored locally"
  s.description = "Analyze Docker images stored locally and provide useful insights."

  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency "filesize"
  s.add_dependency "thor", "~>0.19.0"
  s.add_dependency "terminal-table", "~>1.4.0"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
