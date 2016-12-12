'use strict'
angular.module('public-module.signup-services', [])
	.service('signupServices', function($q, $http) {

	this.signup = function (request) {
        var deferred = $q.defer();
        $http({
            method: 'POST',
            url: '/signup-service.json',
            data: { "name": request.name.value,
                    "last_name": request.lastName.value,
                    "nickname": request.nickname.value,
                    "email": request.email.value,
                    "password": request.password.value,
                    "password_confirmation": request.passwordConfirmation.value,
                    "birthdate": request.birthdate.value},
            headers: {'Content-Type': 'application/json', 'X-CSRF-Token': $('meta[name=csrf-token]').attr('content')}
        }).then(function successCallback(response){ 
            deferred.resolve(response);
        }, function errorCallback(response){
            deferred.reject(response);
        });
               
        return deferred.promise;
    };


});