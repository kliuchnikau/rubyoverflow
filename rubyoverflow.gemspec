# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rubyoverflow/version"

Gem::Specification.new do |s|
  s.name        = "rubyoverflow"
  s.version     = Rubyoverflow::VERSION
  s.authors     = ["Dan Seaver"]
  s.email       = ["git@danseaver.com"]
  s.homepage    = ""
  s.summary     = %q{Rubyoverflow is a Ruby wrapper for the Stack Exchange APIs}
  s.description = %q{Rubyoverflow is a Ruby wrapper for the Stack Exchange APIs}

  s.rubyforge_project = "rubyoverflow"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('httparty')
  s.add_dependency('hashie')
  s.add_dependency('json')
  s.add_development_dependency('rspec')
  s.add_development_dependency('rake')
end
