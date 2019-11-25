require 'test_helper'

module Workarea
  module Storefront
    class SearchAutocompleteViewModelTest < TestCase
      include SearchIndexing

      def test_trending_products
        assert(SearchAutocompleteViewModel.new.trending_products?)
        assert(SearchAutocompleteViewModel.new('foo').trending_products?)

        IndexProduct.perform(create_product(name: 'foo'))
        refute(SearchAutocompleteViewModel.new('foo').trending_products?)

        create_search_by_week(query_string: 'foo', searches: 5, total_results: 5)
        refute(SearchAutocompleteViewModel.new('fo').trending_products?)
      end

      def test_products
        foo = create_product(name: 'Foo', id: 'foo')
        bar = create_product(name: 'Bar', id: 'bar')
        BulkIndexProducts.perform_by_models([foo, bar])

        create_product_by_week(
          product_id: 'foo',
          revenue_change: 10,
          orders: 5,
          reporting_on: Time.zone.local(2018, 12, 3)
        )
        create_product_by_week(
          product_id: 'foo',
          revenue_change: 20,
          orders: 10,
          reporting_on: Time.zone.local(2018, 12, 17)
        )
        create_product_by_week(
          product_id: 'bar',
          revenue_change: 10,
          orders: 5,
          reporting_on: Time.zone.local(2018, 12, 3)
        )

        travel_to Time.zone.local(2019, 1, 17)
        Insights::TrendingProducts.generate_monthly!

        assert_equal(%w(foo bar), SearchAutocompleteViewModel.new.products.map(&:id))
        assert_equal(%w(foo bar), SearchAutocompleteViewModel.new('baz').products.map(&:id))
        assert_equal(%w(foo), SearchAutocompleteViewModel.new('foo').products.map(&:id))

        (Workarea.config.storefront_search_autocomplete_max_products + 1).times do |i|
          IndexProduct.perform(create_product(name: "Foo #{i}"))
        end

        assert_equal(
          Workarea.config.storefront_search_autocomplete_max_products,
          SearchAutocompleteViewModel.new('foo').products.size
        )
      end

      def test_searches
        create_search_by_week(
          query_string: 'foo',
          revenue_change: 10,
          orders: 5,
          total_results: 5,
          reporting_on: Time.zone.local(2018, 12, 3)
        )
        create_search_by_week(
          query_string: 'foo',
          revenue_change: 20,
          orders: 10,
          total_results: 5,
          reporting_on: Time.zone.local(2018, 12, 17)
        )
        create_search_by_week(
          query_string: 'bar',
          revenue_change: 10,
          orders: 5,
          total_results: 5,
          reporting_on: Time.zone.local(2018, 12, 3)
        )

        travel_to Time.zone.local(2019, 1, 17)
        Workarea::Insights::TrendingSearches.generate_monthly!

        assert_equal(%w(foo bar), SearchAutocompleteViewModel.new.searches)
        assert_equal(%w(foo bar), SearchAutocompleteViewModel.new('baz').searches)

        foo = create_product(name: 'Foo')
        bar = create_product(name: 'Bar')
        BulkIndexProducts.perform_by_models([foo, bar])

        assert_equal(%w(foo), SearchAutocompleteViewModel.new('foo').searches)

        (Workarea.config.storefront_search_autocomplete_max_searches + 1).times do |i|
          create_search_by_week(
            query_string: "foo #{i}",
            revenue_change: 10,
            orders: 5,
            total_results: 5,
            reporting_on: Time.zone.local(2018, 12, 3)
          )
        end

        travel_to Time.zone.local(2019, 1, 17)
        Workarea::Insights::TrendingSearches.generate_monthly!

        assert_equal(
          Workarea.config.storefront_search_autocomplete_max_searches,
          SearchAutocompleteViewModel.new('foo').searches.size
        )
      end

      def test_query_string
        assert_nil(SearchAutocompleteViewModel.new.query_string)
        assert_equal('foo', SearchAutocompleteViewModel.new('foo').query_string)

        create_search_by_week(query_string: 'foo', searches: 10, total_results: 5)
        create_search_by_week(query_string: 'foo bar', searches: 5, total_results: 5)

        assert_equal('foo', SearchAutocompleteViewModel.new('foo').query_string)
      end
    end
  end
end
