'use strict'
angular.module('public-module.signin-services', [])
	.service('signinServices', function($q, $http) {

	this.login = function (request) {
        var deferred = $q.defer();
        $http({
            method: 'POST',
            url: '/login-service.json',
            data: {"email": request.email, "password": request.password},
            headers: {'Content-Type': 'application/json', 'X-CSRF-Token': $('meta[name=csrf-token]').attr('content')}
        }).then(function successCallback(response){ 
            deferred.resolve(response);
        }, function errorCallback(response){
            deferred.reject(response);
        });
               
        return deferred.promise;
    };

    this.sendConfirmationlink = function(request){
        var deferred = $q.defer();
        $http({
            method: "POST",
            url: "/send-confirmation-email.json",
            data: {"email": request.email},
            headers: {'Content-Type': 'application/json', 'X-CSRF-Token': $('meta[name=csrf-token]').attr('content')}
        }).then(function successCallback(response){
            deferred.resolve(response);
        }, function errorCallback(response){
            deferred.resolve(response);
        });

        return deferred.promise;
    }

});