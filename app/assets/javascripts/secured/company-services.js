'use strict'
angular.module('admin-module.company-services', [])
	.service('companyServices', function($q, $http) {
		
		this.getCompanies = function(numberPerPage, pageNumber) {
            var deferred = $q.defer();
            var finalUrl = "/private/companies/all-companies/"+numberPerPage+"/"+pageNumber+".json"
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

        this.getTotalOfCompanies = function() {
            var deferred = $q.defer();
            var finalUrl = "/private/companies/all-companies/count.json"
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