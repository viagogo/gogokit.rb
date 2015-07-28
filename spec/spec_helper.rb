require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
]
SimpleCov.start do
  add_filter '/spec/'
  minimum_coverage(99)
end

require 'gogokit'
require 'rspec'
require 'climate_control'
require 'webmock/rspec'

def fixture_path
  File.expand_path('../fixtures', __FILE__)
end

def fixture(file)
  File.new(fixture_path + '/' + file)
end

def with_modified_env(options, &block)
  ClimateControl.modify(options, &block)
end
