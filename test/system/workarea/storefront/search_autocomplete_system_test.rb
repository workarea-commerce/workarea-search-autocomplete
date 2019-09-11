require 'test_helper'

module Workarea
  module Storefront
    class SearchAutocompleteSystemTest < Workarea::SystemTest
      def test_autocomplete
        create_product(name: 'Test One')
        create_product(name: 'Test Two')
        create_search_by_week(query_string: 'test one', searches: 5, total_results: 5)
        create_search_by_week(query_string: 'test two', searches: 10, total_results: 5)

        visit storefront.root_path

        fill_in 'q', with: 'te'

        within '#search_autocomplete' do
          assert_text('Test Two')
          assert_match(/test two.*test one/m, page.body)
        end

        fill_in 'q', with: 'foo'

        assert_selector('#search_autocomplete', visible: false)
      end
    end
  end
end
