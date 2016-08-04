'use strict';

angular.module('admin-module.profile-controller', [])

.controller('all-profiles-controller', ['profileServices', '$scope', '$timeout', function(profileServices, $scope, $timeout) {

	$scope.profiles = {};
	$scope.showPagination = false;
	$scope.totalOfPages = 1;
	$scope.numberPerPage = 25;
	$scope.totalOfProfiles = 0;
	$scope.lastActualPage = 1;
	$scope.actualPage
	$scope.blockPrevious = true;
	$scope.blockNext = false;




	$scope.getProfiles = function(numberPerPage, pageNumber){
		profileServices.getProfiles(numberPerPage, pageNumber).then(function (result) {
			$scope.getTotalOfProfiles();
			$scope.profiles = result.data;
			$scope.showPagination = ($scope.totalOfPages > 1) ? true : false;
		});
	}

	$scope.getTotalOfProfiles = function(){
		profileServices.getTotalOfProfiles().then(function (result) {
			$scope.totalOfProfiles = result.data;
			$scope.setTotalOfPages();
		}); 
	}

	$scope.setTotalOfPages = function(){
		$scope.totalOfPages = ($scope.totalOfProfiles > $scope.numberPerPage) ? parseInt(Math.ceil($scope.totalOfProfiles/$scope.numberPerPage)) : 1;
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
			$scope.getProfiles($scope.numberPerPage, $scope.actualPage);
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


	$scope.getProfiles($scope.numberPerPage, 1);



}]);