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
	$scope.loading = false;
	$scope.showSuccessMessage = false;
	$scope.showForm = true;


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

	$scope.signupMethod = function(){
		socialServices.signup($scope.socialSignup).then(function (result) {
			console.log(result);
			$scope.loading = false;
			if(!result.data.signup){
				$scope.showSignupErrorMessage = true;
				$scope.signupMessage = result.data.errorMessage;
			}else{
				$scope.showForm = false;
				$scope.showSuccessMessage = true;
			}
	    });
	}

	$scope.trySignup = function(){
		$scope.loading = true;
		var valid = true;


		if($scope.socialSignup.nickname.value === ''){
			valid = false;
			$scope.socialSignup.nickname.error = true;
			$scope.socialSignup.nickname.errorMessage = "Campo obrigatório";
		}else{
			$scope.socialSignup.nickname.error = false;
			$scope.socialSignup.nickname.errorMessage = "";
		}

		if($scope.socialSignup.email.value === ''){
			valid = false;
			$scope.socialSignup.email.error = true;
			$scope.socialSignup.email.errorMessage = "Campo obrigatório";
		}else{
			$scope.socialSignup.email.error = false;
			$scope.socialSignup.email.errorMessage = "";
		}

		if($scope.socialSignup.password.value === ''){
			valid = false;
			$scope.socialSignup.password.error = true;
			$scope.socialSignup.password.errorMessage = "Campo obrigatório";
		}else if($scope.socialSignup.password.value.length < 8){
			valid = false;
			$scope.socialSignup.password.error = true;
			$scope.socialSignup.password.errorMessage = "Password deve ter no minimo 8 digitos";
		}else{
			$scope.socialSignup.password.error = false;
			$scope.socialSignup.password.errorMessage = "";
		}

		if($scope.socialSignup.passwordConfirmation.value === ''){
			valid = false;
			$scope.socialSignup.passwordConfirmation.error = true;
			$scope.socialSignup.passwordConfirmation.errorMessage = "Campo obrigatório";
		}else if($scope.socialSignup.passwordConfirmation.value != $scope.socialSignup.password.value){
			valid = false;
			$scope.socialSignup.passwordConfirmation.error = true;
			$scope.socialSignup.passwordConfirmation.errorMessage = "Passwords diferentes";
		}else{
			$scope.socialSignup.passwordConfirmation.error = false;
			$scope.socialSignup.passwordConfirmation.errorMessage = "";
		}


		if($scope.validateEmail($scope.socialSignup.email.value) ){
			$scope.showSignupErrorMessage = false;
			$scope.signupMessage = "";
			if(valid){
				$scope.signupMethod();	
			}
		}else{
			$scope.signupLoading = false;
			$scope.socialSignup.email.error = true;
			$scope.socialSignup.email.errorMessage = "Formato de email inválido";
		}

		if(!valid){
			$scope.loading = false;
		}
	}


	$scope.validateEmail = function(email){
		var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    	return re.test(email);
	}

}])