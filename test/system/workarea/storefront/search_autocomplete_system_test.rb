require 'test_helper'

module Workarea
  module Storefront
    class SearchAutocompleteSystemTest < Workarea::SystemTest
      setup :generate_trending_products, :generate_trending_searches

      def generate_trending_products
        create_product(name: 'Foo Product', id: 'foo_product')
        create_product(name: 'Bar Product', id: 'bar_product')
        create_product(name: 'Baz Product', id: 'baz_product')

        create_product_by_week(
          product_id: 'foo_product',
          revenue_change: 10,
          orders: 5,
          reporting_on: Time.zone.local(2018, 12, 3)
        )
        create_product_by_week(
          product_id: 'foo_product',
          revenue_change: -10,
          orders: 0,
          reporting_on: Time.zone.local(2018, 12, 10)
        )
        create_product_by_week(
          product_id: 'foo_product',
          revenue_change: 20,
          orders: 10,
          reporting_on: Time.zone.local(2018, 12, 17)
        )
        create_product_by_week(
          product_id: 'bar_product',
          revenue_change: 10,
          orders: 5,
          reporting_on: Time.zone.local(2018, 12, 3)
        )
        create_product_by_week(
          product_id: 'bar_product',
          revenue_change: -10,
          orders: 0,
          reporting_on: Time.zone.local(2018, 12, 10)
        )
        create_product_by_week(
          product_id: 'bar_product',
          revenue_change: 0,
          orders: 0,
          reporting_on: Time.zone.local(2018, 12, 17)
        )
        create_product_by_week(
          product_id: 'baz_product',
          revenue_change: 10,
          orders: 5,
          reporting_on: Time.zone.local(2018, 12, 3)
        )
        create_product_by_week(
          product_id: 'baz_product',
          revenue_change: -10,
          orders: 1,
          reporting_on: Time.zone.local(2018, 12, 10)
        )
        create_product_by_week(
          product_id: 'baz_product',
          revenue_change: 0,
          orders: 0,
          reporting_on: Time.zone.local(2018, 12, 17)
        )

        travel_to Time.zone.local(2019, 1, 17)
        Workarea::Insights::TrendingProducts.generate_monthly!
      end

      def generate_trending_searches
        create_search_by_week(
          query_string: 'foo search',
          revenue_change: 10,
          orders: 5,
          reporting_on: Time.zone.local(2018, 12, 3)
        )
        create_search_by_week(
          query_string: 'foo search',
          revenue_change: -10,
          orders: 0,
          reporting_on: Time.zone.local(2018, 12, 10)
        )
        create_search_by_week(
          query_string: 'foo search',
          revenue_change: 20,
          orders: 10,
          reporting_on: Time.zone.local(2018, 12, 17)
        )
        create_search_by_week(
          query_string: 'bar search',
          revenue_change: 10,
          orders: 5,
          reporting_on: Time.zone.local(2018, 12, 3)
        )
        create_search_by_week(
          query_string: 'bar search',
          revenue_change: -10,
          orders: 0,
          reporting_on: Time.zone.local(2018, 12, 10)
        )
        create_search_by_week(
          query_string: 'bar search',
          revenue_change: 0,
          orders: 0,
          reporting_on: Time.zone.local(2018, 12, 17)
        )
        create_search_by_week(
          query_string: 'baz search',
          revenue_change: 10,
          orders: 5,
          reporting_on: Time.zone.local(2018, 12, 3)
        )
        create_search_by_week(
          query_string: 'baz search',
          revenue_change: -10,
          orders: 1,
          reporting_on: Time.zone.local(2018, 12, 10)
        )
        create_search_by_week(
          query_string: 'baz search',
          revenue_change: 0,
          orders: 0,
          reporting_on: Time.zone.local(2018, 12, 17)
        )

        travel_to Time.zone.local(2019, 1, 17)
        Workarea::Insights::TrendingSearches.generate_monthly!
      end

      def test_autocomplete
        create_product(name: 'Test One')
        create_product(name: 'Test Two')
        create_search_by_week(query_string: 'test one', searches: 5, total_results: 5)
        create_search_by_week(query_string: 'test two', searches: 10, total_results: 5)

        visit storefront.root_path
        fill_in 'q', with: ''
        within '#search_autocomplete' do
          assert_text(t('workarea.storefront.search_autocomplete.trending_products'))
          assert_text(t('workarea.storefront.search_autocomplete.trending_searches'))
          assert_match(/Foo Product.*Baz Product.*Bar Product/m, page.body)
          assert_match(/foo search.*baz search.*bar search/m, page.body)
        end

        fill_in 'q', with: 'te'
        within '#search_autocomplete' do
          assert_text('Test Two')
          assert_match(/test two.*test one/m, page.body)
        end

        fill_in 'q', with: ''
        within '#search_autocomplete' do
          assert_text(t('workarea.storefront.search_autocomplete.trending_products'))
          assert_text(t('workarea.storefront.search_autocomplete.trending_searches'))
          assert_match(/Foo Product.*Baz Product.*Bar Product/m, page.body)
          assert_match(/foo search.*baz search.*bar search/m, page.body)
        end

        fill_in 'q', with: 'corge'
        within '#search_autocomplete' do
          assert_text(t('workarea.storefront.search_autocomplete.trending_products'))
          assert_text(t('workarea.storefront.search_autocomplete.trending_searches'))
          assert_match(/Foo Product.*Baz Product.*Bar Product/m, page.body)
          assert_match(/foo search.*baz search.*bar search/m, page.body)
        end
      end
    end
  end
end
