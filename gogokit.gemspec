# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gogokit/version'

Gem::Specification.new do |spec|
  spec.name          = 'gogokit'
  spec.version       = GogoKit::VERSION
  spec.authors       = ['viagogo']
  spec.email         = ['api@viagogo.com']
  spec.summary       = 'Ruby toolkit for working with the viagogo API'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/viagogo/gogokit.rb'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.5'
end
