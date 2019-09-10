(function () {
    'use strict';

    WORKAREA.config.searchAutocomplete = {
        selector: '#storefront_search',
        minLength: 2,
        debounceDelays: {
            input: 1000,
            change: 500
        }
    };
})();

