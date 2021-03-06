'use strict'
angular.module('admin-module.article-services', [])
	.service('articleServices', function($q, $http) {

        this.createArticle = function (request) {
            var deferred = $q.defer();
            $http({
                method: 'POST',
                url: '/private/articles/create_article_service.json',
                data: {"article": request},
                headers: {'Content-Type': 'application/json', 'X-CSRF-Token': $('meta[name=csrf-token]').attr('content')}
            }).then(function successCallback(response){ 
                deferred.resolve(response);
            }, function errorCallback(response){
                deferred.reject(response);
            });
                   
            return deferred.promise;
        };

        this.updateArticle = function (request) {
            var deferred = $q.defer();
            $http({
                method: 'POST',
                url: '/private/articles/update_article_service.json',
                data: {"article": request},
                headers: {'Content-Type': 'application/json', 'X-CSRF-Token': $('meta[name=csrf-token]').attr('content')}
            }).then(function successCallback(response){ 
                deferred.resolve(response);
            }, function errorCallback(response){
                deferred.reject(response);
            });
                   
            return deferred.promise;
        };

        this.deleteFile = function (request) {
            var deferred = $q.defer();
            $http({
                method: 'POST',
                url: '/private/articles/delete_file_service.json',
                data: {"id": request},
                headers: {'Content-Type': 'application/json', 'X-CSRF-Token': $('meta[name=csrf-token]').attr('content')}
            }).then(function successCallback(response){ 
                deferred.resolve(response);
            }, function errorCallback(response){
                deferred.reject(response);
            });
                   
            return deferred.promise;
        };

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