# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'workarea/search_autocomplete/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'workarea-search_autocomplete'
  spec.version     = Workarea::SearchAutocomplete::VERSION
  spec.authors     = ['Ben Crouse']
  spec.email       = ['bcrouse@workarea.com']
  spec.homepage    = <<~HOMEPAGE.chomp
    https://github.com/workarea-commerce/workarea-search-autocomplete
  HOMEPAGE
  spec.summary     = 'Adds search autocomplete to storefront'
  spec.description = 'Adds search autocomplete to storefront'

  spec.files = `git ls-files`.split('\n')

  spec.add_dependency 'workarea', '~> 3.x', '>= 3.5.x'
end
