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
.config(function($datepickerProvider) {
  angular.extend($datepickerProvider.defaults, {
    dateFormat: 'dd/MM/yyyy',
    startWeek: 1
  });
})

.controller('AsideDemoCtrl', function($scope) {
  $scope.aside = {title: 'Menu', content: 'Hello Aside<br />This is a multiline message!'};
})

.controller('signup-controller', function() {
  
  this.constructor = function(){
    this.birthdate = null;
    this.email = ''; 
  }

  this.constructor();
})

