'use strict'
angular.module('admin-module.social-article-services', [])
	.service('socialArticleServices', function($q, $http) {

        this.createSocialArticle = function (request) {
            var deferred = $q.defer();
            $http({
                method: 'POST',
                url: '/private/social-articles/create_social_article_service.json',
                data: {"social_article": request},
                headers: {'Content-Type': 'application/json', 'X-CSRF-Token': $('meta[name=csrf-token]').attr('content')}
            }).then(function successCallback(response){ 
                deferred.resolve(response);
            }, function errorCallback(response){
                deferred.reject(response);
            });
                   
            return deferred.promise;
        };

        this.getFacebookLoginStatus = function(request){
            var deferred = $q.defer();
            FB.getLoginStatus(function(response) {
                deferred.resolve(response);
            })     
            return deferred.promise;
        }


        this.getFacebookPermissions = function(){
            var deferred = $q.defer();
            FB.api('/me/permissions', 'GET',
            {},
              function(response) {
                deferred.resolve(response);
              }
            );

            return deferred.promise;   
        }

        this.getFacebookAccounts = function(){
            var deferred = $q.defer();
            FB.api('/me/accounts', 'GET',
            {},
              function(response) {
                deferred.resolve(response);
              }
            );

            return deferred.promise;   
        }

        this.postOnFacebook = function(request){
            var deferred = $q.defer();
            FB.api('/'+request.pageId+'/feed', 'post', { 
              access_token: request.access_token,
              message     : request.message,
              link        : request.link,
              picture     : request.picture,
              name        : request.name,
              to: request.pageId,
              from: request.pageId,
              description : request.description
          }, 
          function(response) {
            deferred.resolve(response);
          });

            return deferred.promise;
        }

        this.getPageAccessToken = function(facebook_pageId){
            var deferred = $q.defer();
            FB.api('/'+facebook_pageId+'?fields=access_token', 'GET',
            {},
              function(response) {
                deferred.resolve(response);
              }
            );

            return deferred.promise;   
        }


    })