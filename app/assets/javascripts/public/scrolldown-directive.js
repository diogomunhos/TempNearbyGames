'use strict';

angular.module('public-module.scrolldown-directive', [])
.directive('scrolldown', function ($window) {
    return {
        restrict: 'A',
        link: function (scope, element, attrs) {
            angular.element($window).bind('scroll', function () {
                if (($window.innerHeight + $window.scrollY) >= ($(document).height())){
                    scope.$apply(attrs.scrolldown);
                }
            });
        }
    };
});