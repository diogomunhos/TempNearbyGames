'use strict';

angular.module('public-module.scrolldown-directive', [])
.directive('scrolldown', function ($window) {
    return {
        restrict: 'A',
        link: function (scope, element, attrs) {
            console.log('loading directive');
                
            angular.element($window).bind('scroll', function () {
                console.log('in scroll');
                console.log('scroll ' + ($window.innerHeight + $window.scrollY));
                console.log('offset: ' + $(document).height());
                if (($window.innerHeight + $window.scrollY) >= ($(document).height() - 100)){
                    console.log('at bottom');
                }
                // if (raw.scrollTop + raw.offsetHeight > raw.scrollHeight) {
                //     console.log("I am at the bottom");
                //     scope.$apply(attrs.scrolly);
                // }
            });
        }
    };
});