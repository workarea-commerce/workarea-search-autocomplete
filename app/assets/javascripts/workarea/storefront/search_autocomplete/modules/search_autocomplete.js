/**
 * @namespace WORKAREA.searchAutocomplete
 */

WORKAREA.registerModule('searchAutocomplete', (function () {
    'use strict';

    var hide = function () {
            $('#search_autocomplete')
            .addClass('visually-hidden')
            .removeClass('search-autocomplete--visible')
                .closest('.page-header__search-value')
                .removeClass('page-header__search-value--autocomplete');
        },

        render = function (response) {
            $('#search_autocomplete')
            .removeClass('visually-hidden')
            .addClass('search-autocomplete--visible')
            .empty()
            .append(response)
                .closest('.page-header__search-value')
                .addClass('page-header__search-value--autocomplete');
        },

        request = function (input) {
            var endpoint = WORKAREA.routes.storefront.autocompleteSearchPath({
                q: input.value
            });

            $.get(endpoint)
            .done(function (response) {
                $(input).data('searchAutocompletePreviousQuery', input.value);
                render(response);
            })
            .fail(function () {
                $(input).data('searchAutocompletePreviousQuery', null);
                hide();
            });
        },

        duplicateRequest = function (input, value) {
            return $(input).data('searchAutocompletePreviousQuery') === value;
        },

        enoughCharacters = function (value) {
            return value.length >= WORKAREA.config.searchAutocomplete.minLength;
        },

        handleUserClick = function (event) {
            if (_.isEmpty($(event.target).closest($('#search_autocomplete')))) {
                hide();
            }
        },

        handleUserInput = function (event) {
            var value = event.target.value;

            if ( ! enoughCharacters(value)) { return; }
            if (duplicateRequest(event.target, value)) { return; }

            request(event.target);
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
            .on('input', _.debounce(handleUserInput, getDelay('input')))
            .on('change', _.debounce(handleUserInput, getDelay('change')));
        };

    $(window).on('click', handleUserClick);

    return {
        init: init
    };
}()));
