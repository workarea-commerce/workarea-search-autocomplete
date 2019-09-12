require 'test_helper'

module Workarea
  module Storefront
    class SearchAutocompleteIntegrationTest < Workarea::IntegrationTest
      def test_autocomplete
        test_one = create_product(name: 'Test One')
        test_two = create_product(name: 'Test Two')
        create_search_by_week(query_string: 'test one', searches: 5, total_results: 5)
        create_search_by_week(query_string: 'test two', searches: 10, total_results: 5)

        get storefront.autocomplete_search_path(q: '')
        assert(response.ok?)

        get storefront.autocomplete_search_path(q: 'tes')
        assert(response.ok?)
        assert_match(/test two.*test one/m, response.body)
        assert_includes(response.body, storefront.product_path(test_two))
        refute_includes(response.body, storefront.product_path(test_one))

        get storefront.autocomplete_search_path(q: 'TeS')
        assert(response.ok?)
        assert_match(/test two.*test one/m, response.body)
        assert_includes(response.body, storefront.product_path(test_two))
        refute_includes(response.body, storefront.product_path(test_one))
      end
    end
  end
end
