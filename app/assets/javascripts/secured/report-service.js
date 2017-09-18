'use strict'
angular.module('admin-module.report-services', [])
.service('reportServices', function($q, $http) {
		
	this.getArticleAuthorDate = function (request) {
        var deferred = $q.defer();
            $http({
                method: 'POST',
                url: '/private/reports/writer/article_author_date_service.json',
                data: {"request": request},
                headers: {'Content-Type': 'application/json', 'X-CSRF-Token': $('meta[name=csrf-token]').attr('content')}
            }).then(function successCallback(response){ 
                deferred.resolve(response);
            }, function errorCallback(response){
                deferred.reject(response);
            });
                   
            return deferred.promise;
    };

});