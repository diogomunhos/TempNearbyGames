'use strict';

angular.module('admin-module.social-article-controller', ['ngFileUpload'])
.controller('new-social-article-controller', ['socialArticleServices', '$scope', '$timeout', 'Upload', '$q', '$window',  function(socialArticleServices, $scope, $timeout, Upload, $q, $window) {
  
  $scope.socialArticle = {
    postTitle: {
      value: (typeof document.getElementById('hidden_article_post_title') != "undefined" && document.getElementById('hidden_article_post_title') != null) ? document.getElementById('hidden_article_post_title').value : '',
      errorCode: ''
    },
    title: {
      value: (typeof document.getElementById('hidden_article_title') != "undefined" && document.getElementById('hidden_article_title') != null) ? document.getElementById('hidden_article_title').value : '',
      errorCode: ''
    },
    subtitle: {
      value: (typeof document.getElementById('hidden_article_subtitle') != "undefined" && document.getElementById('hidden_article_subtitle') != null) ? document.getElementById('hidden_article_subtitle').value : '',
      errorCode: ''
    },
    friendlyUrl: (typeof document.getElementById('hidden_article_friendly_url') != "undefined" && document.getElementById('hidden_article_friendly_url') != null) ? document.getElementById('hidden_article_friendly_url').value : '',
    documentUrl: (typeof document.getElementById('hidden_article_document_url') != "undefined" && document.getElementById('hidden_article_document_url') != null) ? document.getElementById('hidden_article_document_url').value : '',
    articleId: (typeof document.getElementById('hidden_article_id') != "undefined" && document.getElementById('hidden_article_id') != null) ? document.getElementById('hidden_article_id').value : '',
    socialMedia: {
      id: '',
      name: '',
      api: ''
    },
    socialPostId: {
      value: '',
      errorCode: ''
    },
    stage: 1,
    socialMediaJson: '',
    errorMessage: '',
    submittingMessage: '',
    noSocialMediaAvailableMessage: (typeof document.getElementById('hidden_social_medias_id') != "undefined" && document.getElementById('hidden_social_medias_id') != null) ? '' : 'All social medias registered has a post for this article'

  }
  var teste = new Date();
  console.log(teste);

  $scope.serializeJson = function(){
    $scope.socialArticle.errorMessage = '';
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
        case 'post-title':
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
              if($scope.socialArticle.socialMedia.api === "Facebook"){
                $scope.fbAsyncInit();
              }else if($scope.socialArticle.socialMedia.api === "Google+"){
                $scope.loadGooglePlusAPI();
              }else if($scope.socialArticle.socialMedia.api === "Twitter"){

              }
            }else{
              $scope.isSubmitting = false;
              $scope.socialArticle.errorMessage = "Choose a social media";
            }
            break;
        default:
    }
  }

  $scope.createSocialArticle = function(){
    var request = $scope.createSocialArticleRequest();
    socialArticleServices.createSocialArticle(request).then(function (result) {
        $scope.isSubmitting = false;
        $scope.socialArticle.submittingMessage = '';
        $window.location.href = '/private/articles/show/' + $scope.socialArticle.articleId;
    });
  }

  $scope.createSocialArticleRequest = function(){
    var request = {
        title: $scope.socialArticle.title.value,
        subtitle: $scope.socialArticle.subtitle.value,
        post_title: $scope.socialArticle.postTitle.value,
        article_id: $scope.socialArticle.articleId,
        social_media_id: $scope.socialArticle.socialMedia.id,
        published_id: $scope.socialArticle.socialPostId.value,
        published_time: new Date(),
        status: "Published"
    }
    console.log(request);

    return request;
  }

  $scope.newsValidation = function(){
    var valid = true;
    if($scope.socialArticle.title.value === "" || typeof $scope.socialArticle.title.value === "undefined"){
      $scope.socialArticle.title.errorCode = '1';
      valid = false;
    }
    // if($scope.socialArticle.subtitle.value === "" || typeof $scope.socialArticle.subtitle.value === "undefined"){
    //   $scope.socialArticle.subtitle.errorCode = '1';
    //   valid = false;
    // }
    if($scope.socialArticle.postTitle.value === "" || typeof $scope.socialArticle.postTitle.value === "undefined"){
      $scope.socialArticle.postTitle.errorCode = '1';
      valid = false;
    }
    return valid;
  }


  $scope.previous = function(){
    $scope.socialArticle.errorMessage = '';
    $scope.socialArticle.stage--;
  }

  $scope.finish = function(){
    if($scope.newsValidation()){
      $scope.socialArticle.errorMessage = '';
      $scope.isSubmitting = true;
      $scope.socialArticle.submittingMessage = "Submitting your article, please wait...";
      $scope.fbAsyncInit();
      $scope.postOnFacebook();
    }
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
    socialArticleServices.getFacebookLoginStatus().then(function (response){
      console.log(response);
      if (response.status === 'connected') {
        $scope.getFacebookPermissions();
        // the user is logged in and has authenticated your
        // app, and response.authResponse supplies
        // the user's ID, a valid access token, a signed
        // request, and the time the access token 
        // and signed request each expire
        //var uid = response.authResponse.userID;
        $scope.pageAccessToken = response.authResponse.accessToken;
        $scope.showLoginFacebook = false;
      }else if (response.status === 'not_authorized') {
        console.log('not_authorized');
        $scope.socialArticle.errorMessage = 'This account have no access to facebook page Wahiga';
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
    $scope.socialArticle.errorMessage = '';
    FB.login(function(response){
      console.log(response);
      if(response.authResponse){
        $scope.getFacebookLoginStatus();
        $timeout(function() {
        }, 10);
      }
    }, {scope: ['publish_pages', 'manage_pages']});
  }

  $scope.facebookLogout = function(){
    FB.logout();
    $scope.socialArticle.errorMessage = '';
  }
  

  $scope.getFacebookPermissions = function(){
    console.log("permissions");
    socialArticleServices.getFacebookPermissions().then(function (result) {
      console.log(result.data);
      $scope.permissions = result.data;
      if(!$scope.checkPagePermission()){
        $scope.socialArticle.errorMessage = 'This account have no access to facebook page Wahiga';
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
        $scope.socialArticle.errorMessage = 'This account have no access to facebook page Wahiga';
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
        if(result.id != '' && typeof result.id != "undefined"){
          $scope.socialArticle.socialPostId.value = result.id;
          $scope.createSocialArticle();
        }else{
          $scope.socialArticle.errorMessage = result.error.message;
          $scope.isSubmitting = false;
          $scope.socialArticle.submittingMessage = '';
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
    console.log($scope.socialArticle.friendlyUrl);
    console.log($scope.socialArticle.documentUrl);
    var request = {};
    request.access_token = $scope.pageAccessToken;
    request.message = $scope.socialArticle.postTitle.value;
    request.link = $scope.socialArticle.friendlyUrl;
    request.name = $scope.socialArticle.title.value;
    request.picture = $scope.socialArticle.documentUrl;
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
      version: 'v2.8'
    });

    $scope.getFacebookLoginStatus();
  }


  //Google Plus 
  $scope.googlePlusClientId = "66539190941-7ocangji238qj6ird6gtb9l2e53bjfvn.apps.googleusercontent.com";
  $scope.googlePlusSecretKey = "jhVGbSCO-ITBDTgvA-Q2e9AI";
  $scope.GoogleAuth;
  $scope.googleAccessToken = "";
  $scope.loadGooglePlusAPI = function(){
    gapi.load('auth2', function() {
        gapi.auth2.init({
          client_id: $scope.googlePlusClientId
        }).then(function(GoogleAuth){
          $scope.GoogleAuth = GoogleAuth;
          $scope.GoogleAuth.signIn().then(function(callback){
            console.log(callback);
            $scope.googleAccessToken = callback.access_token;

          });
        })
    });

    //Twitter

    $scope.twitterClientId = "";
    $scope.twitterSecretKey = "";
    
    
    
  }

}]);