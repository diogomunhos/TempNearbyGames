'use strict';

angular.module('admin-module.social-article-controller', ['ngFileUpload'])
.controller('new-social-article-controller', ['socialArticleServices', '$scope', '$timeout', 'Upload', '$q', '$interval', function(socialArticleServices, $scope, $timeout, Upload, $q, $interval) {
  
  $scope.socialArticle = {
    postTitle: {
      value: '',
      errorCode: ''
    },
    title: {
      value: '',
      errorCode: ''
    },
    subtitle: {
      value: '',
      errorCode: ''
    },
    articleId: {
      value: (typeof document.getElementById('hidden_article_id') != "undefined" && document.getElementById('hidden_article_id') != null) ? document.getElementById('hidden_article_id').value : '',
      errorCode: ''
    },
    socialMedia: {
      id: '',
      name: ''
    },
    socialPostId: {
      value: '',
      errorCode: ''
    },
    stage: 1,
    socialMediaJson: ''
  }

  $scope.serializeJson = function(){
    $scope.socialArticle.socialMedia = JSON.parse($scope.socialArticle.socialMediaJson);

  }

  $scope.focusField = function(field){
    switch(field) {
        case 'title':
            $scope.socialArticle.title.errorCode = '';
            break;
        case 'subtitle':
            $scope.socialArticle.subtitle.errorCode = '';
            break;
        case 'post_title':
            $scope.socialArticle.postTitle.errorCode = '';
            break;
        default:   
    }
  }

  $scope.getErrorByCode = function(code, field){
    switch(code) {
        case '1':
            return 'Required field';
            break;
        default:   
    }
  }

  $scope.next = function(){
    $scope.isSubmitting = true;
    console.log($scope.socialArticle);
    switch($scope.socialArticle.stage) {
        case 1:
            if($scope.socialArticle.socialMedia.id != ''){
              $scope.isSubmitting = false;
              $scope.socialArticle.stage++;
              if($scope.socialArticle.socialMedia.name === "Facebook"){
                $scope.fbAsyncInit();
              }
            }
            break;
        default:  
    }
  }

  $scope.createSocialArticle = function(){
    var request = $scope.createSocialArticleRequest();
    socialArticleServices.createSocialArticle(request).then(function (result) {
        console.log(result);
    });
  }

  $scope.createSocialArticleRequest = function(){
    var request = {
        title: $scope.socialArticle.title.value,
        subtitle: $scope.socialArticle.subtitle.value,
        post_title: $scope.socialArticle.postTitle.value,
        article_id: $scope.socialArticle.articleId.value,
        social_media_id: $scope.socialArticle.socialMedia.id,
        published_id: $scope.socialArticle.socialPostId.value,
        status: "Published"
    }
    console.log(request);

    return request;
  }

  $scope.newsValidation = function(){
    var valid = true;
    if($scope.socialArticle.title.value === ""){
      $scope.socialArticle.title.errorCode = '1';
      valid = false;
    }
    if($scope.socialArticle.subtitle.value === ""){
      $scope.socialArticle.subtitle.errorCode = '1';
      valid = false;
    }
    if($scope.socialArticle.postTitle.value === ""){
      $scope.socialArticle.postTitle.errorCode = '1';
      valid = false;
    }

    return valid;
  }


  $scope.previous = function(){
    $scope.article.stage--;
  }

  $scope.finish = function(){
    $scope.postOnFacebook();
  }

  $scope.showFacebookPostButton = false;
  $scope.showLoginFacebook = false;
  $scope.statusArticleOk = false;
  $scope.pageAccessToken = '';
  $scope.permissions = [];
  $scope.errorFacebookMessage = '';
  $scope.wahigaFacebookPageId = '168321086918235';
  //TODO Include Loading on facebook callout 
  $scope.getFacebookLoginStatus = function(){
    FB.getLoginStatus(function(response) {
      if (response.status === 'connected') {
        $scope.getFacebookPermissions();
        // the user is logged in and has authenticated your
        // app, and response.authResponse supplies
        // the user's ID, a valid access token, a signed
        // request, and the time the access token 
        // and signed request each expire
        //var uid = response.authResponse.userID;
        $scope.pageAccessToken = response.authResponse.accessToken;
      }else if (response.status === 'not_authorized') {
        console.log('not_authorized');
        $scope.showLoginFacebook = true;
        $timeout(function() {
        }, 10);
        // the user is logged in to Facebook, 
        // but has not authenticated your app
      }else {
        console.log('not logged');
        $scope.showLoginFacebook = true;
        $timeout(function() {
        }, 10);
        // the user isn't logged in to Facebook.
      }
     });
  }

  $scope.facebookLogin = function(){
    $scope.errorFacebookMessage = '';
    FB.login(function(response){
      if(response.authResponse){
        console.log('teste');
        $scope.showLoginFacebook = false;
        $scope.showFacebookPostButton = true;
        $timeout(function() {
        }, 10);
      }
    }, {scope: ['publish_pages', 'manage_pages']});
  }

  $scope.facebookLogout = function(){
    FB.logout(function(response) {
      console.log('logout');
    });  
  }
  

  $scope.getFacebookPermissions = function(){
    socialArticleServices.getFacebookPermissions().then(function (result) {
      $scope.permissions = result.data;
      if(!$scope.checkPagePermission()){
        $scope.showLoginFacebook = true;
        $scope.showFacebookPostButton = false;
      }else{
        $scope.checkWahigaPageAccess();
      }
      $timeout(function() {
        console.log($scope.showFacebookPostButton);
        console.log($scope.permissions);
      }, 10);
    });
  }

  $scope.checkWahigaPageAccess = function(){
    var valid = false;
    socialArticleServices.getFacebookAccounts().then(function (result){
      for(var i=0; i < result.data.length; i++){
        if(result.data[i].id === $scope.wahigaFacebookPageId){
          valid = true;
        }
      }
      if(!valid){
        $scope.errorFacebookMessage = 'This account have no access to facebook page Wahiga';
        console.log($scope.errorFacebookMessage);
      }else{
        $scope.getPageAccessToken();
      }
    });
  }

  $scope.checkPagePermission = function(){
    var response = {
      publish: false,
      manage: false
    };
    for(var i=0; i < $scope.permissions.length; i++){
      if($scope.permissions[i].permission === 'publish_pages'){
        if($scope.permissions[i].status === 'granted'){
          response.publish = true;
        }
      }else if($scope.permissions[i].permission === 'manage_pages'){
        if($scope.permissions[i].status === 'granted'){
          response.manage = true;
        }
      }
    }

    if(response.publish && response.manage){
      return true;
    }else{
      return false;
    }
  }

  $scope.postOnFacebook = function(){
    //TODO implement Disabled button and show Loading to better UX
    if($scope.showFacebookPostButton){
      $scope.showFacebookPostButton = false;
      var request = $scope.createFacebookPostRequest();
      socialArticleServices.postOnFacebook(request).then(function (result){
        console.log("result facebook post");
        console.log(result);
        if(result.id != ''){
          $scope.socialArticle.socialPostId.value = result.id;
          $scope.createSocialArticle();
        }
      });  
    }
    
  }

  $scope.getPageAccessToken = function(){
    socialArticleServices.getPageAccessToken($scope.wahigaFacebookPageId).then(function (response){
        if(response.access_token != ''){
          $scope.pageAccessToken = response.access_token;
          $scope.showLoginFacebook = false;
          $scope.showFacebookPostButton = true;  
        }
    }); 

  }

  $scope.createFacebookPostRequest = function(){
    var request = {};
    request.access_token = $scope.pageAccessToken;
    request.message = $scope.socialArticle.postTitle.value;
    request.link = "https://www.wahiga.com/red-dead-redemption-2/news/red-dead-redemption-2-e-as-novidades-que-vem-por-ai";
    request.name = $scope.socialArticle.title.value;
    request.picture = "https://www.wahiga.com/images/1577/RedDeadRedemption2-7Riders.jpg";
    request.pageId = $scope.wahigaFacebookPageId;
    request.description = $scope.socialArticle.subtitle.value;
    return request;
  }

  $scope.fbAsyncInit = function() {
    FB.init({ 
      appId: '1735599803381451', //facebook appId
      status: true, 
      cookie: true, 
      xfbml: true,
      version: 'v2.4'
    });

    $scope.getFacebookLoginStatus();
  }

}]);