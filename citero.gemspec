# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "citero/version"

Gem::Specification.new do |s|
  s.name        = 'citero'
  s.version     = Citero::VERSION
  s.platform    = Gem::Platform::RUBY
  s.date        = '2016-10-17'
  s.summary     = "Tool to translate between bibliographic formats."
  s.description = ""
  s.authors     = ["hab278"]
  s.email       = 'hab278@nyu.edu'
  s.homepage    = "https://github.com/NYULibraries/citero-ruby"

  s.files       = Dir["{app,lib,config}/**/*"] + ["Rakefile", "Gemfile", "README.md"]

  s.add_dependency "ox"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "json", "~> 1.7"
  s.add_development_dependency "bundler", "~> 1.2"
  s.add_development_dependency "rspec"
  s.add_development_dependency "pry"
end
