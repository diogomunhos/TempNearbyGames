'use strict';

angular.module('admin-module.article-controller', [])

.controller('all-articles-controller', ['articleServices', '$scope', '$timeout', function(articleServices, $scope, $timeout) {

  $scope.articles = {};
  $scope.articleServices = articleServices;  
  $scope.totalOfArticles = 0;
  $scope.numberPerPage = 10;
  $scope.pageActual = 1;
  $scope.fieldToSearchScreen = "Title";
  $scope.totalOfPages = 1;
  $scope.blockPrevious = true;
  $scope.blockNext = false;
  $scope.lastActualPage = 1;
  $scope.showPagination = false;
  $scope.searchValue = "";
  $scope.fieldToSearch = "title";
  $scope.fieldsToSeach = ["Title", "User", "Status", "Friendly URL"];
  $scope.blockSearch = false;
  $scope.isSearch = false;

  $scope.getArticles = function(numberPerPage, pageNumber){
    $scope.articles = {};
    $scope.showPagination = false;
    if($scope.searchValue === ""){
      articleServices.getArticles(numberPerPage, pageNumber).then(function (result) {
        $scope.getTotalOfArticles(false);
        $scope.articles = result.data;
        $scope.showPagination = ($scope.totalOfPages > 1) ? true : false;
      });
    }else{
      $scope.isSearch = true;
      $scope.getTotalOfArticles(true);
      articleServices.searchArticlesByField(numberPerPage, pageNumber, $scope.fieldToSearch, $scope.searchValue).then(function (result) {
        $scope.articles = result.data;
        $scope.showPagination = ($scope.totalOfPages > 1) ? true : false;
      });
    }
    
  }

  $scope.getTotalOfArticles = function(search){
    if(!search){
      articleServices.getTotalOfArticles().then(function (result) {
        $scope.totalOfArticles = result.data;
        $scope.setTotalOfPages();
      });  
    }else{
      articleServices.getTotalOfArticlesSearch($scope.fieldToSearch, $scope.searchValue).then(function (result) {
        $scope.totalOfArticles = result.data;
        console.log("TOTAL SEARCH " + $scope.totalOfArticles);
        $scope.setTotalOfPages();
      });
    }
     
  }

  $scope.setTotalOfPages = function(){
    $scope.totalOfPages = ($scope.totalOfArticles > $scope.numberPerPage) ? parseInt(Math.ceil($scope.totalOfArticles/$scope.numberPerPage)) : 1;
    $scope.showPagination = ($scope.totalOfPages > 1) ? true : false;
  }

  $scope.goToPage = function(pageNum){
    $scope.blockSearch = false;
    if(typeof pageNum != "undefined" && pageNum != null){
      if(pageNum >= $scope.totalOfPages){
        $scope.pageActual = $scope.totalOfPages;
        $scope.blockPrevious = false;
        $scope.blockNext = true;
      }else if (pageNum <= 1){
        $scope.pageActual = 1;
        $scope.blockPrevious = true;
        $scope.blockNext = false;
      }else{
        $scope.pageActual = pageNum;
        $scope.blockPrevious = false;
        $scope.blockNext = false;
      }
    }else{
      $scope.pageActual = 1;
      $scope.blockPrevious = true;
      $scope.blockNext = false;
    }

    if($scope.lastActualPage != $scope.pageActual){
      $scope.lastActualPage = $scope.pageActual;
      $scope.getArticles($scope.numberPerPage, $scope.pageActual);
    }
  }

  $scope.goToSearch = function(){
    $scope.blockSearch = false;
    if($scope.pageActual >= $scope.totalOfPages){
      $scope.blockPrevious = false;
      $scope.blockNext = true;
    }else if ($scope.pageActual <= 1){
      $scope.blockPrevious = true;
      $scope.blockNext = false;
    }else{
      $scope.blockPrevious = false;
      $scope.blockNext = false;
    }
    if($scope.searchValue != ""){
      $scope.getArticles($scope.numberPerPage, 1);
    }else if($scope.searchValue === "" && $scope.isSearch){
      $scope.clearSearch();
    }  
  }

  $scope.clickGoToSearch = function(){
    if(!$scope.blockSearch){
      $scope.goToSearch();
    }
  }

  $scope.keyPress = function($event){
    if($event.keyCode === 13){
      $event.preventDefault();
      $timeout(function () { $event.target.blur() }, 0, false);
    }
  }

  $scope.focusToPage = function(){
    $scope.blockNext = true;
    $scope.blockPrevious = true;
    $scope.blockSearch = true;
  }

  $scope.prevPage = function(actualPage){
    if(!$scope.blockPrevious){
      actualPage = parseInt(actualPage) - 1;
      $scope.goToPage(actualPage); 
    }  
  }

  $scope.nextPage = function(actualPage){
    if(!$scope.blockNext){
      actualPage = parseInt(actualPage) + 1;
      $scope.goToPage(actualPage);
    }
  }

  $scope.setFieldToSearch = function(value){
    $scope.fieldToSearchScreen = value;
    if(value === "Title"){
      $scope.fieldToSearch = "title";
    }else if (value === "User"){
      $scope.fieldToSearch = "created_by_name";
    }else if (value === "Status"){
      $scope.fieldToSearch = "status";
    }else if (value === "Friendly URL"){
      $scope.fieldToSearch = "friendly_url";
    }
  }

  $scope.clearSearch = function(){
    $scope.isSearch = false;
    $scope.searchValue = "";
    $scope.getArticles($scope.numberPerPage, 1);
  }

  $scope.getArticles($scope.numberPerPage, $scope.pageActual);


}]);