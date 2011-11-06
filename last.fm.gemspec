# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'last.fm/version'

Gem::Specification.new do |s|
  s.name = "last.fm"
  s.version = LastFM::VERSION

  s.authors = ["Sander Nieuwenhuizen"]
  s.email = ["snieuwen@gmail.com"]
  s.description = "This gem acts as a Ruby wrapper around the Last.FM API"
  s.summary = "This gem acts as a Ruby wrapper around the Last.FM API"
  s.files = Dir.glob("{lib,spec}/**/*")

  s.homepage = "http://github.com/munkius/last.fm"
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency("nokogiri", [">= 1.5.0"])

  s.add_development_dependency("fakeweb", [">= 1.3.0"])
  s.add_development_dependency("rspec", [">= 2.7.0"])
  s.add_development_dependency("mocha", [">= 0.10.0"])
  s.add_development_dependency("rake")
end