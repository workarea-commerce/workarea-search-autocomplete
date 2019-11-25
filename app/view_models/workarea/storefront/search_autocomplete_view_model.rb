module Workarea
  module Storefront
    class SearchAutocompleteViewModel < ApplicationViewModel
      def trending_products?
        query_string.blank? || full_results.products.blank?
      end
      alias_method :trending_searches?, :trending_products?

      def products
        @products ||= begin
          results = trending_products? ? trending_products : full_results.products
          results.take(Workarea.config.storefront_search_autocomplete_max_products)
        end
      end

      def searches
        @searches ||= begin
          results = trending_searches? ? trending_searches : autocomplete_searches
          results.take(Workarea.config.storefront_search_autocomplete_max_searches)
        end
      end

      def query_string
        autocomplete_searches.first.presence || model
      end

      def content
        Storefront::SearchViewModel.new(response, options)
      end

      private

      def autocomplete_searches
        return [] if model.blank?

        @autocomplete_searches ||= Metrics::SearchByWeek.autocomplete(
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
        @response ||= Search::StorefrontSearch.new(q: query_string).response
      end
    end
  end
end
