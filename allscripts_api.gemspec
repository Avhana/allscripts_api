
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "allscripts_api/version"

Gem::Specification.new do |spec|
  spec.name          = "allscripts_api"
  spec.version       = AllscriptsApi::VERSION
  spec.authors       = ["Chase"]
  spec.email         = ["chase.gilliam@gmail.com"]

  spec.summary       = "A simple, configurable wrapper around Allscripts APIs"
  spec.description   = %(The allscripts_api gem wraps a set of Allscripts APIs, including
                          but not limited to Unity. The gem focuses on JSON endpoints instead 
                          of SOAP.)
  spec.homepage      = "https://github.com/Avhana/allscripts_api"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", ">= 0.12.2"
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "pronto"
  spec.add_development_dependency "pronto-rubocop"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "yard", "~> 0.9"
  spec.add_development_dependency "webmock", "~> 3.3"
end
