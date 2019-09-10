module Workarea
  module Storefront
    class SearchAutocompleteViewModel < ApplicationViewModel
      def products
        return [] if searches.blank?
        full_results.products.take(Workarea.config.storefront_search_autocomplete_max_products)
      end

      def full_results
        @full_results ||= SearchViewModel.wrap(response, options)
      end

      def response
        @response ||= Search::StorefrontSearch.new(q: searches.first).response
      end

      def searches
        @searches ||= Metrics::SearchByWeek.autocomplete(
          model,
          max: Workarea.config.storefront_search_autocomplete_max_searches
        )
      end

      def no_results?
        products.empty? && searches.empty?
      end
    end
  end
end
