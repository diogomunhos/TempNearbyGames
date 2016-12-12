'use strict';

angular.module('public-module.social-login-controller', [])
.controller('social-login-controller', ['socialServices', '$scope', '$window', function(socialServices, $scope, $window) {

	$scope.socialSignin = {
		email: '',
		password: ''
	}

	$scope.socialSignup = {
		nickname: { value: '',
					error: false,
					errorMessage:''},
		email: { 	value: '',
					error: false,
					errorMessage:''},
		password: { value: '',
					error: false,
					errorMessage:''},
		passwordConfirmation: { value: '',
								error: false,
								errorMessage:''}
	}

	$scope.showLoginErrorMessage = false;
	$scope.loginMessage = "";
	$scope.loginLoading = false;
	$scope.showSignupErrorMessage = false;
	$scope.signupMessage = "";
	$scope.signupLoading = false;


	$scope.login = function(){
		socialServices.login($scope.socialSignin).then(function (result) {
			$scope.loginLoading = false;
			if(result.data.login){
				$window.location.href = '/';
			}else{
				$scope.showLoginErrorMessage = true;
				$scope.loginMessage = result.data.errorMessage;
			}
	    });
	}

	$scope.tryLogin = function(){
		$scope.loginLoading = true;
		if($scope.validateEmail($scope.socialSignin.email)){
			if($scope.socialSignin.password != null && $scope.socialSignin.password != ""){
				$scope.showLoginErrorMessage = false;
				$scope.loginMessage = "";
				$scope.login();
			}else{
				$scope.loginLoading = false;
				$scope.showLoginErrorMessage = true;
				$scope.loginMessage = "Digite sua senha";
			}
		}else{
			$scope.loginLoading = false;
			$scope.showLoginErrorMessage = true;
			$scope.loginMessage = "Formato de email inválido";
		}
	}

	$scope.signup = function(){

	}

	$scope.trySignup = function(){
		
	}


	$scope.validateEmail = function(email){
		var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    	return re.test(email);
	}

}])