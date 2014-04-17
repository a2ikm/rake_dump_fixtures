# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rake_dump_fixtures/version'

Gem::Specification.new do |spec|
  spec.name          = "rake_dump_fixtures"
  spec.version       = RakeDumpFixtures::VERSION
  spec.authors       = ["Masato Ikeda"]
  spec.email         = ["masato.ikeda@gmail.com"]
  spec.summary       = %q{Add `rake db:fixtures:dump` task to extract records to YAML fixtures.}
  spec.description   = %q{Add `rake db:fixtures:dump` task to extract records to YAML fixtures. You can specify dumping tables.}
  spec.homepage      = "https://github.com/a2ikm/rake_dump_fixtures"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 4.0.0"
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
