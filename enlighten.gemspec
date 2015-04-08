# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'enlighten/version'

Gem::Specification.new do |spec|
  spec.name          = "enlighten"
  spec.version       = Enlighten::VERSION
  spec.authors       = ["Robert Martin"]
  spec.email         = ["rob@rob-martin.net"]
  spec.summary       = %q{Use this gem to connect to the enphase 'enlighten' API.  }
  spec.description   = %q{Docs at https://developer.enphase.com/docs}
  spec.homepage      = "https://www.github.com/datadude/enlighten"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end

