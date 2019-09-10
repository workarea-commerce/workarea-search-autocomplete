(function () {
    'use strict';

    WORKAREA.config.searchAutocomplete = {
        selector: '#storefront_search',
        minLength: 2,
        delays: {
            input: 1000,
            change: 500,
            blur: 250
        }
    };
})();

