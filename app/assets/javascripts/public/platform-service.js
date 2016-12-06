'use strict'
angular.module('public-module.platform-services', [])
	.service('platformServices', function($q, $http) {
		
		this.getArticles = function (pageNumber, numberPerPage, platform) {
            var deferred = $q.defer();
            $http({
                method: 'GET',
                url: "/"+platform+"/get-articles-paged/"+numberPerPage+"/"+pageNumber+".json"
            }).then(function successCallback(response){ 
                deferred.resolve(response);
            }, function errorCallback(response){
                deferred.reject(response);
            });
                   
            return deferred.promise;
        };

});