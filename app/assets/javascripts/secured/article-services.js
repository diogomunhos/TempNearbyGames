'use strict'
angular.module('admin-module.article-services', [])
	.service('articleServices', function($q, $http) {

        this.getArticles = function (numberPerPage, pageNumber) {
            var deferred = $q.defer();
            console.log('numberPerPage ' + numberPerPage);
            console.log('pageNumber ' + pageNumber);
            var finalUrl = "/private/articles/all-articles/"+numberPerPage+"/"+pageNumber+".json"
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

        this.searchArticlesByField = function (numberPerPage, pageNumber, fieldToSearch, searchValue) {
            var deferred = $q.defer();
            var finalUrl = "/private/articles/all-articles/search/"+fieldToSearch+"/"+searchValue+"/"+numberPerPage+"/"+pageNumber+".json"
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

        this.getTotalOfArticles = function () {
            var deferred = $q.defer();
            var finalUrl = "/private/articles/all-articles/count.json"
            $http({
            	method: 'GET',
            	url: finalUrl
            }).then(function successCallback(response){
            	console.log('COUNT ' + JSON.stringify(response))
            	deferred.resolve(response);
            }, function errorCallback(response){
            	deferred.reject(response);
            });
                   
            return deferred.promise;
        };

        this.getTotalOfArticlesSearch = function (fieldToSearch, searchValue) {
            var deferred = $q.defer();
            var finalUrl = "/private/articles/all-articles/count/"+fieldToSearch+"/"+searchValue+".json"
            $http({
            	method: 'GET',
            	url: finalUrl
            }).then(function successCallback(response){
            	console.log('COUNT Search service ' + JSON.stringify(response))
            	deferred.resolve(response);
            }, function errorCallback(response){
            	deferred.reject(response);
            });
                   
            return deferred.promise;
        };
    })