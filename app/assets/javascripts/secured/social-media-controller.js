'use strict';

angular.module('admin-module.social-media-controller', [])

.controller('all-social-medias-controller', ['socialMediaServices', '$scope', '$timeout', function(socialMediaServices, $scope, $timeout) {

	$scope.socialMedias = {};
	$scope.showPagination = false;
	$scope.totalOfPages = 1;
	$scope.numberPerPage = 25;
	$scope.totalOfSocialMedias = 0;
	$scope.lastActualPage = 1;
	$scope.actualPage
	$scope.blockPrevious = true;
	$scope.blockNext = false;




	$scope.getSocialMedias = function(numberPerPage, pageNumber){
		socialMediaServices.getSocialMedias(numberPerPage, pageNumber).then(function (result) {
			$scope.getTotalOfSocialMedias();
			$scope.socialMedias = result.data;
			$scope.showPagination = ($scope.totalOfPages > 1) ? true : false;
		});
	}

	$scope.getTotalOfSocialMedias = function(){
		socialMediaServices.getTotalOfSocialMedias().then(function (result) {
			$scope.totalOfSocialMedias = result.data;
			$scope.setTotalOfPages();
		}); 
	}

	$scope.setTotalOfPages = function(){
		$scope.totalOfPages = ($scope.totalOfSocialMedias > $scope.numberPerPage) ? parseInt(Math.ceil($scope.totalOfSocialMedias/$scope.numberPerPage)) : 1;
		$scope.showPagination = ($scope.totalOfPages > 1) ? true : false;
	}

	$scope.goToPage = function(pageNum){
		if(typeof pageNum != "undefined" && pageNum != null){
			if(pageNum >= $scope.totalOfPages){
				$scope.actualPage = $scope.totalOfPages;
				$scope.blockPrevious = false;
				$scope.blockNext = true;
			}else if (pageNum <= 1){
				$scope.actualPage = 1;
				$scope.blockPrevious = true;
				$scope.blockNext = false;
			}else{
				$scope.actualPage = pageNum;
				$scope.blockPrevious = false;
				$scope.blockNext = false;
			}
		}else{
			$scope.actualPage = 1;
			$scope.blockPrevious = true;
			$scope.blockNext = false;
		}

		if($scope.lastActualPage != $scope.actualPage){
			$scope.lastActualPage = $scope.actualPage;
			$scope.getSocialMedias($scope.numberPerPage, $scope.actualPage);
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


	$scope.getSocialMedias($scope.numberPerPage, 1);
}])
.controller('edit-social-media-controller', ['socialMediaServices', '$scope', '$timeout', function(socialMediaServices, $scope, $timeout) {
	$scope.socialMedia = {
		name: document.getElementById('social_media_name').value
	}
}]);