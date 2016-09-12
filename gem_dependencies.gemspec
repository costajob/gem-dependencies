# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "gem_dependencies/version"

Gem::Specification.new do |spec|
  spec.name          = "gem_dependencies"
  spec.version       = GemDependencies::VERSION
  spec.authors       = ["costajob"]
  spec.email         = ["costajob@gmail.com"]

  spec.summary       = "A tiny library to visualize and count gem dependencies recursively"
  spec.homepage      = "https://github.com/costajob/gem_dependencies"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
