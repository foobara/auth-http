require_relative "version"

Gem::Specification.new do |spec|
  spec.name = "foobara-auth-http"
  spec.version = Foobara::AuthHttp::VERSION
  spec.authors = ["Miles Georgi"]
  spec.email = ["azimux@gmail.com"]

  spec.summary = "Contains convenience classes/methods for using Foobara::Auth over HTTP"
  spec.homepage = "https://github.com/foobara/auth-http"
  spec.license = "Apache-2.0 OR MIT"
  spec.required_ruby_version = Foobara::AuthHttp::MINIMUM_RUBY_VERSION

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files = Dir[
    "lib/**/*",
    "src/**/*",
    "LICENSE*.txt",
    "README.md",
    "CHANGELOG.md"
  ]

  spec.add_dependency "foobara", ">= 0.1.1", "< 2.0.0"
  spec.add_dependency "foobara-auth", "< 2.0.0"
  spec.add_dependency "foobara-http-command-connector", "< 2.0.0"

  spec.require_paths = ["lib"]
  spec.metadata["rubygems_mfa_required"] = "true"
end
