'use strict'
angular.module('public-module.article-services', [])
	.service('articleServices', function($q, $http) {
		
		this.getArticles = function (pageNumber, numberPerPage) {
            var deferred = $q.defer();
            $http({
                method: 'GET',
                url: "/all-articles/get-articles-from-page/"+numberPerPage+"/"+pageNumber+".json"
            }).then(function successCallback(response){ 
                deferred.resolve(response);
            }, function errorCallback(response){
                deferred.reject(response);
            });
                   
            return deferred.promise;
        };

});