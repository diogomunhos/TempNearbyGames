'use strict'
angular.module('admin-module.social-media-services', [])
	.service('socialMediaServices', function($q, $http) {
		
		this.getSocialMedias = function(numberPerPage, pageNumber) {
            var deferred = $q.defer();
            var finalUrl = "/private/social-medias/all-social-medias/"+numberPerPage+"/"+pageNumber+".json"
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

        this.getTotalOfSocialMedias = function() {
            var deferred = $q.defer();
            var finalUrl = "/private/social-medias/all-social-medias/count.json"
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