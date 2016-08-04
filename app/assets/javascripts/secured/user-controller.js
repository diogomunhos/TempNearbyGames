'use strict';

angular.module('admin-module.user-controller', [])

.controller('all-users-controller', ['userServices', '$scope', '$timeout', function(userServices, $scope, $timeout) {

	$scope.users = {};
	$scope.showPagination = false;
	$scope.totalOfPages = 1;
	$scope.numberPerPage = 25;
	$scope.totalOfUsers = 0;
	$scope.lastActualPage = 1;
	$scope.actualPage
	$scope.blockPrevious = true;
	$scope.blockNext = false;




	$scope.getUsers = function(numberPerPage, pageNumber){
		userServices.getUsers(numberPerPage, pageNumber).then(function (result) {
			$scope.getTotalOfUsers();
			$scope.users = result.data;
			$scope.showPagination = ($scope.totalOfPages > 1) ? true : false;
		});
	}

	$scope.getTotalOfUsers = function(){
		userServices.getTotalOfUsers().then(function (result) {
			$scope.totalOfUsers = result.data;
			$scope.setTotalOfPages();
		}); 
	}

	$scope.setTotalOfPages = function(){
		$scope.totalOfPages = ($scope.totalOfUsers > $scope.numberPerPage) ? parseInt(Math.ceil($scope.totalOfUsers/$scope.numberPerPage)) : 1;
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
			$scope.getUsers($scope.numberPerPage, $scope.actualPage);
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


	$scope.getUsers($scope.numberPerPage, 1);



}])
.controller('edit-user-controller', ['userServices', '$scope', '$timeout', function(userServices, $scope, $timeout) {

	$scope.user = {
		name: document.getElementById('user_name').value,
		last_name: document.getElementById('user_last_name').value,
		nickname: document.getElementById('user_nickname').value,
		email: document.getElementById('user_email').value,
		profile: document.getElementById('user_profile_name').value
	}

	$scope.selectProfile = function(profileName, profileId){
		console.log('entrou');
		$scope.user.profile = profileName;
	}

}]);