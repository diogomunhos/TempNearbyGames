var app = angular.module('mgcrea.ngStrapDocs', ['ngAnimate', 'ngSanitize', 'mgcrea.ngStrap']);

app.controller('MainCtrl', function($scope) {
});

'use strict';

angular.module('mgcrea.ngStrapDocs')

.config(function($asideProvider) {
  angular.extend($asideProvider.defaults, {
    container: 'body',
    html: true
  });
})

.controller('AsideDemoCtrl', function($scope) {
  $scope.aside = {title: 'Menu', content: 'Hello Aside<br />This is a multiline message!'};
});