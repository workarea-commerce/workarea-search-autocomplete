Workarea::Configuration.define_fields do
  fieldset 'Search', namespaced: false do
    field 'Storefront Search Autocomplete Max Searches',
      type: :integer,
      default: 5,
      description: 'The max number of search autocomplete suggestions to show in the storefront.'

    field 'Storefront Search Autocomplete Max Products',
      type: :integer,
      default: 4,
      description: 'The max number of search autocomplete products to show in the storefront.'
  end
end
