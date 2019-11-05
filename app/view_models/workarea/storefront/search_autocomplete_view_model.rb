module Workarea
  module Storefront
    class SearchAutocompleteViewModel < ApplicationViewModel
      def products
        return [] if searches.blank?
        full_results.products.take(Workarea.config.storefront_search_autocomplete_max_products)
      end

      def trending_products
        @trending_products ||= SearchAutocompleteProductsViewModel.wrap(
          Workarea::Insights::TrendingProducts.current,
          options
        )
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

      def trending_searches
        @trending_searches ||= begin
          Workarea::Insights::TrendingSearches.current.results.map do |v|
            v['query_string']
          end
        end
      end

      def content
        Storefront::SearchViewModel.new(response, options)
      end
    end
  end
end
