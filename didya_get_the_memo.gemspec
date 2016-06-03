# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'didya_get_the_memo/version'

Gem::Specification.new do |spec|
  spec.name          = 'didya_get_the_memo'
  spec.version       = DidyaGetTheMemo::VERSION
  spec.authors       = ['Matt Clark']
  spec.email         = ['matt.clark.1@gmail.com']

  spec.summary       = 'Simple, effective memoization.'
  spec.description   = "Memoization so simple you could have written it. But I did it, so you don't have to."
  spec.homepage      = 'https://github.com/mclark/didya_get_the_memo'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.' unless spec.respond_to?(:metadata)

  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
end
