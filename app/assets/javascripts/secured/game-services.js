'use strict'
angular.module('admin-module.game-services', [])
	.service('gameServices', function($q, $http) {

        this.createGame = function (request) {
            var deferred = $q.defer();
            $http({
                method: 'POST',
                url: '/private/games/create_game_service.json',
                data: {"game": request},
                headers: {'Content-Type': 'application/json', 'X-CSRF-Token': $('meta[name=csrf-token]').attr('content')}
            }).then(function successCallback(response){ 
                deferred.resolve(response);
            }, function errorCallback(response){
                deferred.reject(response);
            });
                   
            return deferred.promise;
        };

        this.createGameCompanies = function (request) {
            var deferred = $q.defer();
            $http({
                method: 'POST',
                url: '/private/games/create_game_companies_service.json',
                data: request,
                headers: {'Content-Type': 'application/json', 'X-CSRF-Token': $('meta[name=csrf-token]').attr('content')}
            }).then(function successCallback(response){ 
                deferred.resolve(response);
            }, function errorCallback(response){
                deferred.reject(response);
            });
                   
            return deferred.promise;
        };

        this.destroyGameCompany = function (request) {
            var deferred = $q.defer();
            $http({
                method: 'POST',
                url: '/private/games/destroy_game_company_service.json',
                data: request,
                headers: {'Content-Type': 'application/json', 'X-CSRF-Token': $('meta[name=csrf-token]').attr('content')}
            }).then(function successCallback(response){ 
                deferred.resolve(response);
            }, function errorCallback(response){
                deferred.reject(response);
            });
                   
            return deferred.promise;
        };

        this.updateGame = function (request) {
            var deferred = $q.defer();
            $http({
                method: 'POST',
                url: '/private/games/update_game_service.json',
                data: {"game": request},
                headers: {'Content-Type': 'application/json', 'X-CSRF-Token': $('meta[name=csrf-token]').attr('content')}
            }).then(function successCallback(response){ 
                deferred.resolve(response);
            }, function errorCallback(response){
                deferred.reject(response);
            });
                   
            return deferred.promise;
        };

        this.getGames = function (numberPerPage, pageNumber) {
            var deferred = $q.defer();
            console.log('numberPerPage ' + numberPerPage);
            console.log('pageNumber ' + pageNumber);
            var finalUrl = "/private/games/all-games/"+numberPerPage+"/"+pageNumber+".json"
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

        this.searchGamesByField = function (numberPerPage, pageNumber, fieldToSearch, searchValue) {
            var deferred = $q.defer();
            var finalUrl = "/private/games/all-games/search/"+fieldToSearch+"/"+searchValue+"/"+numberPerPage+"/"+pageNumber+".json"
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

        this.getTotalOfGames = function () {
            var deferred = $q.defer();
            var finalUrl = "/private/games/all-games/count.json"
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

        this.getTotalOfGamesSearch = function (fieldToSearch, searchValue) {
            var deferred = $q.defer();
            var finalUrl = "/private/games/all-games/count/"+fieldToSearch+"/"+searchValue+".json"
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