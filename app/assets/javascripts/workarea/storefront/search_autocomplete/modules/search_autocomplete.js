/**
 * @namespace WORKAREA.searchAutocomplete
 */

WORKAREA.registerModule('searchAutocomplete', (function () {
    'use strict';

    var cache = {},
        hide = function () {
            $('#search_autocomplete')
            .addClass('visually-hidden')
            .removeClass('search-autocomplete--visible')
                .closest('.page-header__search-value')
                .removeClass('page-header__search-value--autocomplete');
        },

        render = function (response) {
            var $response = $(response);

            WORKAREA.initModules($response);

            $('#search_autocomplete')
            .removeClass('visually-hidden')
            .addClass('search-autocomplete--visible')
            .empty()
            .append($response)
                .closest('.page-header__search-value')
                .addClass('page-header__search-value--autocomplete');
        },

        handleUserClick = function (event) {
            if (!$(event.target).is($(WORKAREA.config.searchAutocomplete.selector))) {
                hide();
            }
        },

        handleUserInput = function (event) {
            var endpoint = WORKAREA.routes.storefront.autocompleteSearchPath({
                q: event.target.value
            });

            if (cache[endpoint]) {
                render(cache[endpoint]);
            } else {
                $.get(endpoint)
                .fail(function () { hide(); })
                .done(function (response) {
                    cache[endpoint] = response;
                    render(response);
                });
            }

        },

        getDelay = function (type) {
            if (WORKAREA.environment.isTest) {
                return 0;
            } else {
                return WORKAREA.config.searchAutocomplete.delays[type];
            }
        },

        /**
         * @method
         * @name init
         * @memberof WORKAREA.searchAutocomplete
         */
        init = function ($scope) {
            $(WORKAREA.config.searchAutocomplete.selector, $scope)
            .on('focus', _.debounce(handleUserInput, getDelay('focus')))
            .on('input', _.debounce(handleUserInput, getDelay('input')))
            .on('change', _.debounce(handleUserInput, getDelay('change')));
        };

    $(window).on('click', handleUserClick);

    return {
        init: init
    };
}()));
