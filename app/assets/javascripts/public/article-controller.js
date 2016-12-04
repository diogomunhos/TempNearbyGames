'use strict';

angular.module('public-module.article-controller', [])
.controller('all-articles-controller', ['articleServices', '$scope', '$timeout', '$window', function(articleServices, $scope, $timeout, $window) {
	
	$scope.totalOfRecords = 0;
	$scope.totalOfPages = 0;
	$scope.actualPage = 1;


	$scope.getArticles = function(){

	}

	$scope.getTotalOfRecords = function(){

	}

	$scope.setTotalOfPages = function(){

	}

	$scope.testScroll = function(){
		console.log('call testScroll');
	}

	$scope.changePage = function(pageNumber){
		$scope.actualPage = pageNumber;
		$scope.getArticles();
	}

}]);