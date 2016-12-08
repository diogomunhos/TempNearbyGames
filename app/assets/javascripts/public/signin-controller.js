'use strict';

angular.module('public-module.signin-controller', [])
.controller('signin-controller', ['signinServices', '$scope', '$window', function(signinServices, $scope, $window) {

	$scope.signin = {
		email: '',
		password: ''
	}
	$scope.showErrorMessage = false;
	$scope.message = "";
	$scope.loading = false;


	$scope.login = function(){
		signinServices.login($scope.signin).then(function (result) {
			$scope.loading = false;
			if(result.data.login){
				$window.location.href = '/';
			}else{
				$scope.showErrorMessage = true;
				$scope.message = "Email e/ou senha inválido(s)";
			}
	    });
	}

	$scope.tryLogin = function(){
		$scope.loading = true;
		if($scope.validateEmail($scope.signin.email)){
			if($scope.signin.password != null && $scope.signin.password != ""){
				$scope.showErrorMessage = false;
				$scope.message = "";
				$scope.login();
			}else{
				$scope.loading = false;
				$scope.showErrorMessage = true;
				$scope.message = "Digite sua senha";
			}
		}else{
			$scope.loading = false;
			$scope.showErrorMessage = true;
			$scope.message = "Formato de email inválido";
		}
	}


	$scope.validateEmail = function(email){
		var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    	return re.test(email);
	}

}])