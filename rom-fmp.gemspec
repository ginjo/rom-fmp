# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rom/fmp/version'

Gem::Specification.new do |spec|
  spec.name          = "rom-fmp"
  spec.version       = ROM::FMP::VERSION
  spec.authors       = ["wbr"]
  spec.email         = ["wbr@mac.com"]
  spec.summary       = %q{Filemaker adapter for rom-rb}
  spec.description   = %q{Allows ROM to use Filemaker Server as a datastore}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rom", "~> 0.9"
  spec.add_runtime_dependency "ginjo-rfm", "~> 3.0.11"  
  spec.add_runtime_dependency "charlatan", "~> 0.1"

  spec.add_development_dependency "bundler"#, "~> 1.7"
  spec.add_development_dependency "rake"#, "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.2"
end
