'use strict';

angular.module('admin-module.company-controller', [])

.controller('all-companies-controller', ['companyServices', '$scope', '$timeout', function(companyServices, $scope, $timeout) {

	$scope.companies = {};
	$scope.showPagination = false;
	$scope.totalOfPages = 1;
	$scope.numberPerPage = 25;
	$scope.totalOfCompanies = 0;
	$scope.lastActualPage = 1;
	$scope.actualPage
	$scope.blockPrevious = true;
	$scope.blockNext = false;




	$scope.getCompanies = function(numberPerPage, pageNumber){
		companyServices.getCompanies(numberPerPage, pageNumber).then(function (result) {
			$scope.getTotalOfCompanies();
			$scope.companies = result.data;
			$scope.showPagination = ($scope.totalOfPages > 1) ? true : false;
		});
	}

	$scope.getTotalOfCompanies = function(){
		companyServices.getTotalOfCompanies().then(function (result) {
			$scope.totalOfCompanies = result.data;
			$scope.setTotalOfPages();
		}); 
	}

	$scope.setTotalOfPages = function(){
		$scope.totalOfPages = ($scope.totalOfCompanies > $scope.numberPerPage) ? parseInt(Math.ceil($scope.totalOfCompanies/$scope.numberPerPage)) : 1;
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
			$scope.getCompanies($scope.numberPerPage, $scope.actualPage);
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


	$scope.getCompanies($scope.numberPerPage, 1);
}])
.controller('edit-company-controller', ['companyServices', '$scope', '$timeout', function(companyServices, $scope, $timeout) {
	$scope.company = {
		name: document.getElementById('company_name').value
	}
}]);