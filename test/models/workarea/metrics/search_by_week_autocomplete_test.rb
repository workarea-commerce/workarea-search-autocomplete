require 'test_helper'

module Workarea
  module Metrics
    class SearchByWeekAutocompleteTest < TestCase
      def test_autocomplete
        create_search_by_week(total_results: 0, query_string: 'test one')
        create_search_by_week(total_results: 5, query_string: 'test two', reporting_on: 1.week.ago.beginning_of_week)
        create_search_by_week(total_results: 5, query_string: 'test two', reporting_on: 2.weeks.ago.beginning_of_week)
        create_search_by_week(searches: 3, total_results: 10, query_string: 'test three')
        create_search_by_week(total_results: 15, query_string: 'blah blah blah')

        results = SearchByWeek.autocomplete('tes')
        assert_equal(2, results.size)
        assert_equal('test three', results.first)
        assert_equal('test two', results.second)
      end
    end
  end
end
