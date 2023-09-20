# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby-dice/version'

Gem::Specification.new do |spec|
  spec.name          = 'ruby-dice'
  spec.version       = RubyDice::VERSION
  spec.authors       = ['Ivan Vega', 'Shane Short']
  spec.email         = ['shanes@webinabox.net.au']
  spec.summary       = %q{Ruby Diceware passphrase generator}
  spec.description   = %q{Simple Ruby library to generate "Diceware" passphrases.}
  spec.homepage      = 'https://github.com/ivanyv/ruby-dice'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'thor'

  spec.add_development_dependency 'bundler', '~> 2.2'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec',   '~> 3.1'
end
