lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gogokit/version'

Gem::Specification.new do |spec|
  spec.name          = 'gogokit'
  spec.version       = GogoKit::VERSION
  spec.authors       = ['viagogo']
  spec.email         = ['api@viagogo.com']
  spec.description   = 'Ruby toolkit for working with the viagogo API'
  spec.summary       = 'viagogo API library'
  spec.homepage      = 'https://github.com/viagogo/gogokit.rb'
  spec.licenses      = 'MIT'

  spec.files         = %w(LICENSE.txt README.md Rakefile gogokit.gemspec)
  spec.files         = spec.files + Dir.glob('lib/**/*.rb')
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 1.9.3'
  spec.required_rubygems_version = '>= 1.3.5'

  spec.add_dependency 'faraday', '~> 0.9.1'
  spec.add_dependency 'addressable', '~> 2.3'
  spec.add_dependency 'roar', '~> 1.0'
  spec.add_dependency 'multi_json', '~> 1.11'
  spec.add_dependency 'virtus', '~> 1.0'

  spec.add_development_dependency 'bundler', '~> 1.5'
end
