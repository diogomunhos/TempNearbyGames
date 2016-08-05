'use strict';

angular.module('admin-module.application-controller', [])

.controller('navleft-controller', ['applicationServices', '$scope', '$timeout', function(applicationServices, $scope, $timeout) {

  $scope.articles = {
    showArticles: false,
    showNew: false,
    showAll: false
  };

  $scope.management = {
    showManagement: false,
    profile: {
      showProfile: false,
      showAll: false,
      showNew: false
    },
    user: {
      showUsers: false,
      showAll: false,
      showNew: false
    }
  };

  $scope.permissions = null;
  
  $scope.getPermissions = function(){
    if($scope.permissions === null){
      applicationServices.getPermissions().then(function (result) {
        console.log('permissions: ' + JSON.stringify(result.data));
        $scope.permissions = result.data;
        $scope.setPermissions();
      });
    }
  }


  $scope.setPermissions = function(){
    console.log('asda ' + $scope.permissions.length);
    for (var i = 0; i < $scope.permissions.length; i++){
      if($scope.permissions[i].object_name === "Article"){
        if($scope.permissions[i].read_all_record === true || $scope.permissions[i].create_record === true){
          $scope.articles.showArticles = true;
          $scope.articles.showAll = ($scope.permissions[i].read_all_record === true) ? true : false;
          $scope.articles.showNew = ($scope.permissions[i].create_record === true) ? true : false;
        }
      }else if($scope.permissions[i].object_name === "User" ){
        if($scope.permissions[i].read_all_record === true || $scope.permissions[i].create_record === true){
          $scope.management.showManagement = true;
          $scope.management.user.showUsers = true;
          $scope.management.user.showAll = ($scope.permissions[i].read_all_record === true) ? true : false;
          $scope.management.user.showNew = ($scope.permissions[i].create_record === true) ? true : false;
        }
      }else if($scope.permissions[i].object_name === "Profile"){
        if($scope.permissions[i].read_all_record === true || $scope.permissions[i].create_record === true){
          $scope.management.showManagement = true;
          $scope.management.profile.showProfile = true;
          $scope.management.profile.showAll = ($scope.permissions[i].read_all_record === true) ? true : false;
          $scope.management.profile.showNew = ($scope.permissions[i].create_record === true) ? true : false;
        }
      }
    } 
  }

   $scope.getPermissions();

}]);