# frozen_string_literal: true
# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'three_scale_api/version'

Gem::Specification.new do |spec|
  spec.name          = 'ThreeScaleRest'
  spec.version       = ThreeScaleApi::VERSION
  spec.authors       = ['Peter Stanko', 'Jakub Cechacek']
  spec.email         = ['pstanko@redhat.com', 'jcechace@redhat.com']

  spec.summary       = 'API Client for 3scale APIs'
  spec.description   = 'API Client to access your 3scale APIs: Account Management API'
  spec.homepage      = 'https://github.com/3scale'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 12.1'
  spec.add_development_dependency 'rspec', '~> 3.6'
  spec.add_development_dependency 'rspec-mocks', '~> 3.6'
end
