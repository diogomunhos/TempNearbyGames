'use strict';

angular.module('public-module.article-controller', [])
.controller('all-articles-controller', ['articleServices', '$scope', '$timeout', '$window', function(articleServices, $scope, $timeout, $window) {
	
	$scope.totalOfRecords = 0;
	$scope.totalOfPages = 0;
	$scope.actualPage = 1;
	$scope.articles = [];
	$scope.loadingArticles = true;


	$scope.getArticles = function(){
		articleServices.getArticles($scope.actualPage, 10).then(function (result) {
			$scope.loadingArticles = false;
	        for(var i=0; i < result.data.length; i++){
	        	$scope.articles.push({id: result.data[i].id, title: result.data[i].title, preview: result.data[i].preview, url: result.data[i].url, image_url: result.data[i].image_url});
	        }
	    });
	}

	$scope.testScroll = function(){
		if(!$scope.loadingArticles){
			$scope.loadginArticles = true;
			$scope.actualPage++;
			$scope.getArticles();
		}
	}

	$scope.getArticles();

}]);