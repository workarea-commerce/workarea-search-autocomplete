Workarea.append_partials(
  'storefront.page_header_search_value',
  'workarea/storefront/searches/autocomplete_placeholder'
)

Workarea.append_javascripts(
  'storefront.config',
  'workarea/storefront/search_autocomplete/config'
)

Workarea.append_javascripts(
  'storefront.modules',
  'workarea/storefront/search_autocomplete/modules/search_autocomplete'
)

Workarea.append_stylesheets(
  'storefront.components',
  'workarea/storefront/search_autocomplete/components/page_header',
  'workarea/storefront/search_autocomplete/components/search_autocomplete'
)
