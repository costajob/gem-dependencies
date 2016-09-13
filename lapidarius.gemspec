# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "lapidarius/version"

Gem::Specification.new do |s|
  s.name = "lapidarius"
  s.version = Lapidarius::VERSION
  s.authors = ["costajob"]
  s.email = ["costajob@gmail.com"]

  s.required_ruby_version = ">= 2.1.8"
  s.summary = "A tiny library to visualize and count gem dependencies recursively"
  s.homepage = "https://github.com/costajob/lapidarius"

  s.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.bindir = "exe"
  s.executables = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "bundler", "~> 1.12"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "minitest", "~> 5.0"
end
