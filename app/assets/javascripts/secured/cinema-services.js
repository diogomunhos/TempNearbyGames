'use strict'
angular.module('admin-module.cinema-services', [])
	.service('cinemaServices', function($q, $http) {

        this.createCinema = function (request) {
            var deferred = $q.defer();
            $http({
                method: 'POST',
                url: '/private/cinemas/create_cinema_service.json',
                data: {"cinema": request},
                headers: {'Content-Type': 'application/json', 'X-CSRF-Token': $('meta[name=csrf-token]').attr('content')}
            }).then(function successCallback(response){ 
                deferred.resolve(response);
            }, function errorCallback(response){
                deferred.reject(response);
            });
                   
            return deferred.promise;
        };

        this.createCinemaCompanies = function (request) {
            var deferred = $q.defer();
            $http({
                method: 'POST',
                url: '/private/cinemas/create_cinema_companies_service.json',
                data: request,
                headers: {'Content-Type': 'application/json', 'X-CSRF-Token': $('meta[name=csrf-token]').attr('content')}
            }).then(function successCallback(response){ 
                deferred.resolve(response);
            }, function errorCallback(response){
                deferred.reject(response);
            });
                   
            return deferred.promise;
        };

        this.destroyCinemaCompany = function (request) {
            var deferred = $q.defer();
            $http({
                method: 'POST',
                url: '/private/cinemas/destroy_cinema_company_service.json',
                data: request,
                headers: {'Content-Type': 'application/json', 'X-CSRF-Token': $('meta[name=csrf-token]').attr('content')}
            }).then(function successCallback(response){ 
                deferred.resolve(response);
            }, function errorCallback(response){
                deferred.reject(response);
            });
                   
            return deferred.promise;
        };

        this.updateCinema = function (request) {
            var deferred = $q.defer();
            $http({
                method: 'POST',
                url: '/private/cinemas/update_cinema_service.json',
                data: {"cinema": request},
                headers: {'Content-Type': 'application/json', 'X-CSRF-Token': $('meta[name=csrf-token]').attr('content')}
            }).then(function successCallback(response){ 
                deferred.resolve(response);
            }, function errorCallback(response){
                deferred.reject(response);
            });
                   
            return deferred.promise;
        };

        this.getCinemas = function (numberPerPage, pageNumber) {
            var deferred = $q.defer();
            console.log('numberPerPage ' + numberPerPage);
            console.log('pageNumber ' + pageNumber);
            var finalUrl = "/private/cinemas/all-cinemas/"+numberPerPage+"/"+pageNumber+".json"
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

        this.searchCinemasByField = function (numberPerPage, pageNumber, fieldToSearch, searchValue) {
            var deferred = $q.defer();
            var finalUrl = "/private/cinemas/all-cinemas/search/"+fieldToSearch+"/"+searchValue+"/"+numberPerPage+"/"+pageNumber+".json"
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

        this.getTotalOfCinemas = function () {
            var deferred = $q.defer();
            var finalUrl = "/private/cinemas/all-cinemas/count.json"
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

        this.getTotalOfCinemasSearch = function (fieldToSearch, searchValue) {
            var deferred = $q.defer();
            var finalUrl = "/private/cinemas/all-cinemas/count/"+fieldToSearch+"/"+searchValue+".json"
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