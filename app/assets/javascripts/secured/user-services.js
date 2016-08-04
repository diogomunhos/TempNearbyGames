'use strict'
angular.module('admin-module.user-services', [])
	.service('userServices', function($q, $http) {
		
		this.getUsers = function(numberPerPage, pageNumber) {
            var deferred = $q.defer();
            var finalUrl = "/private/users/all-users/"+numberPerPage+"/"+pageNumber+".json"
            $http({
            	method: 'GET',
            	url: finalUrl
            }).then(function successCallback(response){
                console.log('response ' + JSON.stringify(response)) 
            	deferred.resolve(response);
            }, function errorCallback(response){
                console.log('response Error ' + JSON.stringify(response))
            	deferred.reject(response);
            });
                   
            return deferred.promise;
        };

        this.getTotalOfUsers = function() {
            var deferred = $q.defer();
            var finalUrl = "/private/users/all-users/count.json"
            $http({
            	method: 'GET',
            	url: finalUrl
            }).then(function successCallback(response){
            	deferred.resolve(response);
            }, function errorCallback(response){
            	deferred.reject(response);
            });
                   
            return deferred.promise;
        };

	});