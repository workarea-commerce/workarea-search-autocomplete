/**
 * @namespace WORKAREA.searchAutocomplete
 */

WORKAREA.registerModule('searchAutocomplete', (function () {
    'use strict';

    var

        render = function (input, response) {

        },

        replace = function (input, response) {

        },

        request = function (input) {
            var endpoint = WORKAREA.routes.storefront.autocompleteSearchPath({
                q: input.value
            });

            $.get(endpoint).done(function (response) {
                if ($(input).data('searchAutocompleteElement')) {
                    replace(input, response);
                } else {
                    render(input, response);
                }
            });
        },

        duplicateRequest = function (input, value) {
            return $(input).data('searchAutocompletePreviousQuery') === value;
        }

        enoughCharacters = function (value) {
            return value.length >= WORKAREA.config.searchAutocomplete.minLength;
        },

        check = function (event) {
            var value = event.target.value;

            if (!enoughCharacters(value)) { return; }
            if (duplicateRequest(event.target, value)) { return; }

            request(event.target);
        },

        getDelay = function (type) {
            if (WORKAREA.environment.isTest) {
                return 0;
            } else {
                return WORKAREA.config.searchAutocomplete.debounceDelays[type];
            }
        },

        /**
         * @method
         * @name init
         * @memberof WORKAREA.searchAutocomplete
         */

        init = function ($scope) {
            $(WORKAREA.config.searchAutocomplete.selector, $scope)
            .on('input', _.debounce(check, getDelay('input')))
            .on('change', _.debounce(check, getDelay('change')));
        };

    return {
        init: init
    };
}()));
