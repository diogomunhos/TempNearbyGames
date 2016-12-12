'use strict';

angular.module('public-module.signup-controller', [])
.controller('signup-controller', ['signupServices', '$scope', '$window', function(signupServices, $scope, $window) {

	$scope.signup = {
		name:{	value: '', 
			   	error: false,
			   	errorMessage: ''},
		lastName:{	value: '', 
			   	error: false,
			   	errorMessage: ''},
		nickname:{	value: '', 
			   	error: false,
			   	errorMessage: ''},
		birthdate:{	value: '', 
			   	error: false,
			   	errorMessage: ''},	   		   		   	
		email:{	value: '', 
			   	error: false,
			   	errorMessage: ''},
		password: {value: '', 
			   	error: false,
			   	errorMessage: ''},
		passwordConfirmation: {value: '', 
			   	error: false,
			   	errorMessage: ''}	   	
	};

	$scope.showErrorMessage = false;
	$scope.message = "";
	$scope.loading = false;
	$scope.showForm = true;
	$scope.showSuccessMessage = false;


	$scope.signupMethod = function(){
		signupServices.signup($scope.signup).then(function (result) {
			$scope.loading = false;
			console.log(result);
			if(!result.data.signup){
				$scope.showErrorMessage = true;
				$scope.message = result.data.errorMessage;
			}else{
				$scope.showForm = false;
				$scope.showSuccessMessage = true;
			}
	    });
	}

	$scope.trySignup = function(){
		$scope.loading = true;
		var valid = true;

		if($scope.signup.name.value === ''){
			valid = false;
			$scope.signup.name.error = true;
			$scope.signup.name.errorMessage = "Campo obrigatório";
		}else{
			$scope.signup.name.error = false;
			$scope.signup.name.errorMessage = "";
		}

		if($scope.signup.lastName.value === ''){
			valid = false;
			$scope.signup.lastName.error = true;
			$scope.signup.lastName.errorMessage = "Campo obrigatório";
		}else{
			$scope.signup.lastName.error = false;
			$scope.signup.lastName.errorMessage = "";
		}

		if($scope.signup.nickname.value === ''){
			valid = false;
			$scope.signup.nickname.error = true;
			$scope.signup.nickname.errorMessage = "Campo obrigatório";
		}else{
			$scope.signup.nickname.error = false;
			$scope.signup.nickname.errorMessage = "";
		}

		if($scope.signup.birthdate.value === ''){
			valid = false;
			$scope.signup.birthdate.error = true;
			$scope.signup.birthdate.errorMessage = "Campo obrigatório";
		}else if(!$scope.validateDate($scope.signup.birthdate.value)){
			$scope.signup.birthdate.error = true;
			$scope.signup.birthdate.errorMessage = "Formato de data inválido dd/mm/yyyy";
		}else{
			$scope.signup.birthdate.error = false;
			$scope.signup.birthdate.errorMessage = "";
		}

		if($scope.signup.email.value === ''){
			valid = false;
			$scope.signup.email.error = true;
			$scope.signup.email.errorMessage = "Campo obrigatório";
		}else{
			$scope.signup.email.error = false;
			$scope.signup.email.errorMessage = "";
		}

		if($scope.signup.password.value === ''){
			valid = false;
			$scope.signup.password.error = true;
			$scope.signup.password.errorMessage = "Campo obrigatório";
		}else if($scope.signup.password.value.length < 8){
			valid = false;
			$scope.signup.password.error = true;
			$scope.signup.password.errorMessage = "Password deve ter no minimo 8 digitos";
		}else{
			$scope.signup.password.error = false;
			$scope.signup.password.errorMessage = "";
		}

		if($scope.signup.passwordConfirmation.value === ''){
			valid = false;
			$scope.signup.passwordConfirmation.error = true;
			$scope.signup.passwordConfirmation.errorMessage = "Campo obrigatório";
		}else if($scope.signup.passwordConfirmation.value != $scope.signup.password.value){
			valid = false;
			$scope.signup.passwordConfirmation.error = true;
			$scope.signup.passwordConfirmation.errorMessage = "Passwords diferentes";
		}else{
			$scope.signup.passwordConfirmation.error = false;
			$scope.signup.passwordConfirmation.errorMessage = "";
		}


		if($scope.validateEmail($scope.signup.email.value) ){
			$scope.showErrorMessage = false;
			$scope.message = "";
			if(valid){
				$scope.signupMethod();	
			}
		}else{
			$scope.loading = false;
			$scope.signup.email.error = true;
			$scope.signup.email.errorMessage = "Formato de email inválido";
		}
	}


	$scope.validateEmail = function(email){
		var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    	return re.test(email);
	}

	$scope.validateDate = function(date){
		var pattern =/^([0-9]{2})\/([0-9]{2})\/([0-9]{4})$/;
		return pattern.test(date);
	}

}])