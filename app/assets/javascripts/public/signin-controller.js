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
	$scope.showLink = false;
	$scope.showConfirmationMessage = false;
	$scope.confirmationMessage = "";

	$scope.lastSigninTry = {
		email: '',
		password: ''	
	}


	$scope.login = function(){
		$scope.lastSigninTry.email = $scope.signin.email;
		$scope.lastSigninTry.password = $scope.signin.password;
		signinServices.login($scope.signin).then(function (result) {
			$scope.loading = false;
			if(result.data.login){
				$window.location.href = '/';
			}else{
				$scope.showErrorMessage = true;
				$scope.showLink = result.data.showLink;
				$scope.message = result.data.errorMessage;
			}
	    });
	}

	$scope.tryLogin = function(){
		$scope.showConfirmationMessage = false;
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

	$scope.sendEmailConfirmationLink = function(){
		console.log('test');
		$scope.showErrorMessage = false;
		$scope.showConfirmationMessage = true;
		$scope.confirmationMessage = "O email de confirmação foi enviado para " + $scope.lastSigninTry.email + " verifique sua caixa de email.";
		signinServices.sendConfirmationlink($scope.lastSigninTry).then(function (result) {});
	}


	$scope.validateEmail = function(email){
		var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    	return re.test(email);
	}

}])