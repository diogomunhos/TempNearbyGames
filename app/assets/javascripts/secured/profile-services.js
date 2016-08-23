'use strict'
angular.module('admin-module.profile-services', [])
	.service('profileServices', function($q, $http) {
		
        this.saveProfile = function (request) {
            var deferred = $q.defer();
            var finalUrl = "/private/profiles/my-profile/save.json"
            $http({
                method: 'POST',
                url: finalUrl,
                data: {"profile": request},
                headers: {'Content-Type': 'application/json', 'X-CSRF-Token': $('meta[name=csrf-token]').attr('content')}
            }).then(function successCallback(response){ 
                deferred.resolve(response);
            }, function errorCallback(response){
                deferred.reject(response);
            });
                   
            return deferred.promise;
        };

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