# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'polycom/version'

Gem::Specification.new do |spec|
  spec.name          = "polycom"
  spec.version       = Polycom::VERSION
  spec.authors       = ["Sumit Birla"]
  spec.email         = ["sbirla@tampahost.net"]
  spec.description   = %q{Library and utility for interacting with Polycom IP Phones}
  spec.summary       = %q{Uses web-api of Polycom phones to do data push, read notifications and retrieve configuration information}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = ["polycom"]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_dependency "sinatra"
	spec.add_dependency "net-http-digest_auth"
	spec.add_dependency "activesupport"
end
