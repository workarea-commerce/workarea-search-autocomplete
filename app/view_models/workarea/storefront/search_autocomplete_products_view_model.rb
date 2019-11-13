module Workarea
  module Storefront
    class SearchAutocompleteProductsViewModel < RecommendationsViewModel
      def product_ids
        model.results.map { |v| v['product_id'] }
      end

      def result_count
        Workarea.config.storefront_search_autocomplete_max_products
      end
    end
  end
end
