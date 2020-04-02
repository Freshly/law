
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "law/version"

Gem::Specification.new do |spec|
  spec.name          = "law"
  spec.version       = Law::VERSION
  spec.authors       = [ "Eric Garside", "Brandon Trumpold" ]
  spec.email         = %w[garside@gmail.com brandon.trumpold@gmail.com]

  spec.summary       = "Give illegal operations a whole new meaning with this policy enforcement"
  spec.description   = "Enforce the laws of your Rails application with highly extensible access policies"
  spec.homepage      = "https://github.com/Freshly/law/tree/master"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/Freshly/law/blob/master/CHANGELOG.md"

  spec.files         = Dir["README.md", "LICENSE.txt", "lib/**/{*,.[a-z]*}"]
  spec.require_paths = "lib"

  spec.add_runtime_dependency "activesupport", ">= 5.2.1"
  spec.add_runtime_dependency "spicery", ">= 0.22.3.1", "< 1.0"

  spec.add_development_dependency "bundler", "~> 2.0.1"
  spec.add_development_dependency "pry-byebug", ">= 3.7.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "simplecov", "0.17.1"
  spec.add_development_dependency "timecop", ">= 0.9.1"
  spec.add_development_dependency "shoulda-matchers", "4.0.1"

  spec.add_development_dependency "rspice", ">= 0.22.3.1", "< 1.0"
  spec.add_development_dependency "spicerack-styleguide", ">= 0.22.3.1", "< 1.0"
end
