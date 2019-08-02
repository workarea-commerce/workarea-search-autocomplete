require 'workarea/testing/teaspoon'

Teaspoon.configure do |config|
  config.root = Workarea::SearchAutocomplete::Engine.root
  Workarea::Teaspoon.apply(config)
end
