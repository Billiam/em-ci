# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'em-ci/version'

Gem::Specification.new do |gem|
  gem.name          = "em-ci"
  gem.version       = EmCi::VERSION
  gem.authors       = ["Billiam"]
  gem.email         = ["billiamthesecond@gmail.com"]
  gem.description   = %q{Utility library for monitoring CI servers}
  gem.summary       = %q{EventMachine-friendly CI server monitor}
  gem.homepage      = ""

  gem.files         = Dir["{lib}/**/*.rb", "{lib}/**/*.rake", "{lib}/**/*.yml", "LICENSE", "*.md"]
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency('eventmachine', '~> 1.0.3')
  gem.add_dependency('em-http-request', '~> 1.0.3')
  gem.add_dependency('em-promise', '~> 1.1.1')
  gem.add_dependency('nokogiri', '~> 1.5.9')
end
