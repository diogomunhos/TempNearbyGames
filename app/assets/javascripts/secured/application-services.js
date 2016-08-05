'use strict'
angular.module('admin-module.application-services', [])
	.service('applicationServices', function($q, $http) {
		
		this.getPermissions = function () {
            var deferred = $q.defer();
            $http({
                method: 'GET',
                url: "/private/index/get-permissions.json"
            }).then(function successCallback(response){ 
                deferred.resolve(response);
            }, function errorCallback(response){
                deferred.reject(response);
            });
                   
            return deferred.promise;
        };

	});