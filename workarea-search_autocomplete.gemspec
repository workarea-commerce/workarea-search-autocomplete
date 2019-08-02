$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "workarea/search_autocomplete/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "workarea-search_autocomplete"
  spec.version     = Workarea::SearchAutocomplete::VERSION
  spec.authors     = ["Ben Crouse"]
  spec.email       = ["bcrouse@workarea.com"]
  spec.homepage    = "https://www.workarea.com"
  spec.summary     = "Adds search autocomplete to storefront"
  spec.description = "Adds search autocomplete to storefront"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = 'https://gems.weblinc.com'
  end

  spec.files = `git ls-files`.split("\n")
end
