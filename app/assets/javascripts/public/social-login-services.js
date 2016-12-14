'use strict'
angular.module('public-module.social-services', [])
	.service('socialServices', function($q, $http) {

	this.login = function (request) {
        var deferred = $q.defer();
        $http({
            method: 'POST',
            url: '/login-social-service.json',
            data: {"email": request.email, "password": request.password},
            headers: {'Content-Type': 'application/json', 'X-CSRF-Token': $('meta[name=csrf-token]').attr('content')}
        }).then(function successCallback(response){ 
            deferred.resolve(response);
        }, function errorCallback(response){
            deferred.reject(response);
        });
               
        return deferred.promise;
    };

    this.signup = function (request) {
        var deferred = $q.defer();
        $http({
            method: 'POST',
            url: '/signup-service.json',
            data: { "nickname": request.nickname.value,
                    "email": request.email.value,
                    "password": request.password.value,
                    "password_confirmation": request.passwordConfirmation.value},
            headers: {'Content-Type': 'application/json', 'X-CSRF-Token': $('meta[name=csrf-token]').attr('content')}
        }).then(function successCallback(response){ 
            deferred.resolve(response);
        }, function errorCallback(response){
            deferred.reject(response);
        });
               
        return deferred.promise;
    };



});