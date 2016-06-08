# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fond_memos/version'

Gem::Specification.new do |spec|
  spec.name          = 'fond_memos'
  spec.version       = FondMemos::VERSION
  spec.authors       = ['Matt Clark']
  spec.email         = ['matt.clark.1@gmail.com']

  spec.summary       = 'Simple, effective memoization.'
  spec.description   = "Memoization so simple you could have written it. But I did, so you don't have to."
  spec.homepage      = 'https://github.com/mclark/fond_memos'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.' unless spec.respond_to?(:metadata)

  spec.files         = ['lib/fond_memos.rb', 'lib/fond_memos/version.rb']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.12', '>= 1.12.5'
  spec.add_development_dependency 'rake', '~> 11.1', '>= 11.1.2'
  spec.add_development_dependency 'minitest', '~> 5.9'
end
