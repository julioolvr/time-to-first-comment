# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'time_to_first_comment/version'

Gem::Specification.new do |spec|
  spec.name          = 'time_to_first_comment'
  spec.version       = TimeToFirstComment::VERSION
  spec.authors       = ['Julio Olivera']
  spec.email         = ['julio.olvr@gmail.com']

  spec.summary       = 'Utility to check how much time passed until the first comment was added to a Pull Request'
  spec.homepage      = 'https://github.com/julioolvr/time-to-first-comment'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = ['time_to_first_comment']
  spec.require_paths = ['lib']

  spec.add_dependency 'octokit', '~> 4.2'
  spec.add_dependency 'chronic_duration', '~> 0.10'
  spec.add_dependency 'slop', '~> 3.0'

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.35'
  spec.add_development_dependency 'pry', '~> 0.10'
end
