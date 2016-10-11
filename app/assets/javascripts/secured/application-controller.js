'use strict';

angular.module('admin-module.application-controller', [])

.controller('navleft-controller', ['applicationServices', '$scope', '$timeout', '$location', function(applicationServices, $scope, $timeout, $location) {

  $scope.articles = {
    showArticles: false,
    showNew: false,
    showAll: false
  };

  $scope.companies = {
    showCompanies: false,
    showNew: false,
    showAll: false
  };

  $scope.games = {
    showGames: false,
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

  $scope.activeLinkFirst = "home"
  $scope.activeLinkSecond = ""
  $scope.activeLinkThird = ""
  

  $scope.setActiveLinks = function(){
    var path = $location.absUrl();
    if(path.indexOf("/articles") !== -1){
      $scope.activeLinkFirst = "article";
      $scope.activeLinkSecond = "all-article";
      $scope.activeLinkThird = "";
      if(path.indexOf("/new") !== -1){
        $scope.activeLinkSecond = "new-article";
      }else if (path.indexOf("/show") !== -1 || path.indexOf("/edit") !== -1){
        $scope.activeLinkSecond = "";
      }
    }if(path.indexOf("/companies") !== -1){
      $scope.activeLinkFirst = "company";
      $scope.activeLinkSecond = "all-company";
      $scope.activeLinkThird = "";
      if(path.indexOf("/new") !== -1){
        $scope.activeLinkSecond = "new-company";
      }else if (path.indexOf("/show") !== -1 || path.indexOf("/edit") !== -1){
        $scope.activeLinkSecond = "";
      }
    }if(path.indexOf("/games") !== -1){
      $scope.activeLinkFirst = "game";
      $scope.activeLinkSecond = "all-game";
      $scope.activeLinkThird = "";
      if(path.indexOf("/new") !== -1){
        $scope.activeLinkSecond = "new-game";
      }else if (path.indexOf("/show") !== -1 || path.indexOf("/edit") !== -1){
        $scope.activeLinkSecond = "";
      }
    }else if(path.indexOf("/users") !== -1){
      $scope.activeLinkFirst = "management";
      $scope.activeLinkSecond = "user"
       $scope.activeLinkThird = "all-user"
      if(path.indexOf("/new") !== -1){
        $scope.activeLinkThird = "new-user";
      }else if (path.indexOf("/show") !== -1 || path.indexOf("/edit") !== -1){
        $scope.activeLinkThird = ""
      }
    }else if(path.indexOf("/profiles") !== -1){
      $scope.activeLinkFirst = "management";
      $scope.activeLinkSecond = "profile"
       $scope.activeLinkThird = "all-profile"
      if(path.indexOf("/new") !== -1){
        $scope.activeLinkThird = "new-profile";
      }else if (path.indexOf("/show") !== -1 || path.indexOf("/edit") !== -1){
        $scope.activeLinkThird = ""
      }
    }else{
      $scope.activeLinkFirst = "home"
      $scope.activeLinkSecond = ""
      $scope.activeLinkThird = ""
    }
     
  }
  

  $scope.permissions = null;
  
  $scope.getPermissions = function(){
    if($scope.permissions === null){
      applicationServices.getPermissions().then(function (result) {
        $scope.permissions = result.data;
        $scope.setPermissions();
      });
    }
  }


  $scope.setPermissions = function(){
    for (var i = 0; i < $scope.permissions.length; i++){
      if($scope.permissions[i].object_name === "Article"){
        if($scope.permissions[i].read_all_record === true || $scope.permissions[i].create_record === true){
          $scope.articles.showArticles = true;
          $scope.articles.showAll = ($scope.permissions[i].read_all_record === true) ? true : false;
          $scope.articles.showNew = ($scope.permissions[i].create_record === true) ? true : false;
        }
      }if($scope.permissions[i].object_name === "Company"){
        if($scope.permissions[i].read_all_record === true || $scope.permissions[i].create_record === true){
          $scope.companies.showCompanies = true;
          $scope.companies.showAll = ($scope.permissions[i].read_all_record === true) ? true : false;
          $scope.companies.showNew = ($scope.permissions[i].create_record === true) ? true : false;
        }
      }if($scope.permissions[i].object_name === "Game"){
        if($scope.permissions[i].read_all_record === true || $scope.permissions[i].create_record === true){
          $scope.games.showGames = true;
          $scope.games.showAll = ($scope.permissions[i].read_all_record === true) ? true : false;
          $scope.games.showNew = ($scope.permissions[i].create_record === true) ? true : false;
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
   $scope.setActiveLinks();

}]);