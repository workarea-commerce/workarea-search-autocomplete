module Workarea
  module SearchAutocomplete
    class Engine < ::Rails::Engine
      include Workarea::Plugin
      isolate_namespace Workarea::SearchAutocomplete
    end
  end
end
