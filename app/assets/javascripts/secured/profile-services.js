'use strict'
angular.module('admin-module.profile-services', [])
	.service('profileServices', function($q, $http) {
		
		this.getProfiles = function (numberPerPage, pageNumber) {
            var deferred = $q.defer();
            var finalUrl = "/private/profiles/all-profiles/"+numberPerPage+"/"+pageNumber+".json"
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

        this.getTotalOfProfiles = function () {
            var deferred = $q.defer();
            var finalUrl = "/private/profiles/all-profiles/count.json"
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