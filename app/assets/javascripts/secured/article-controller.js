'use strict';

angular.module('admin-module.article-controller', ['ngFileUpload'])
.controller('article-detail-controller', ['articleServices', '$scope', '$timeout', '$window', function(articleServices, $scope, $timeout, $window) {
    
    $scope.showFacebookPostButton = false;
    $scope.showLoginFacebook = false;
    $scope.pageAccessToken = '';
    $scope.permissions = [];
    $scope.errorFacebookMessage = '';
    $scope.wahigaFacebookPageId = '168321086918235';
    $scope.article = {
      id: ((typeof document.getElementById("article_id") != "undefined") ? document.getElementById("article_id").value : ""),
      status: ((typeof document.getElementById("article_status") != "undefined") ? document.getElementById("article_status").value : ""),
      preview: ((typeof document.getElementById("article_preview_hidden") != "undefined") ? document.getElementById("article_preview_hidden").value : ""),
      facebook_picture: ((typeof document.getElementById("article_facebook_picture") != "undefined") ? document.getElementById("article_facebook_picture").value : ""),
      facebook_title: ((typeof document.getElementById("article_title_hidden") != "undefined") ? document.getElementById("article_title_hidden").value : ""),
      facebook_message: ((typeof document.getElementById("article_subtitle_hidden") != "undefined") ? document.getElementById("article_subtitle_hidden").value : ""),
      friendly_url: ((typeof document.getElementById("article_friendly_url_hidden") != "undefined") ? document.getElementById("article_friendly_url_hidden").value : ""),
      facebook_post_id: ((typeof document.getElementById("article_facebook_post_id") != "undefined") ? document.getElementById("article_facebook_post_id").value : "")
    }
    //TODO Include Loading on facebook callout 
    $scope.getFacebookLoginStatus = function(){
      if($scope.article.facebook_post_id != ''){
        $scope.showLoginFacebook = false;
        $scope.showFacebookPostButton = false;
      }else{

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
          } else if (response.status === 'not_authorized') {
            console.log('not_authorized');
            $scope.showLoginFacebook = true;
            $timeout(function() {
            }, 10);
            // the user is logged in to Facebook, 
            // but has not authenticated your app
          } else {
            console.log('not logged');
            $scope.showLoginFacebook = true;
            $timeout(function() {
            }, 10);
            // the user isn't logged in to Facebook.
          }
         });
      }
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
      articleServices.getFacebookPermissions().then(function (result) {
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
      articleServices.getFacebookAccounts().then(function (result){
        for(var i=0; i < result.data.length; i++){
          if(result.data[i].id === $scope.wahigaFacebookPageId){
            valid = true;
          }
        }
        if(!valid){
          $scope.errorFacebookMessage = 'This account have no access to facebook page Wahiga';
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
      var request = $scope.createFacebookPostRequest();
      articleServices.postOnFacebook(request).then(function (result){
        if(result.id != ''){
          var requestPost = {
            id: $scope.article.id,
            post_id: result.id
          }
          articleServices.updateArticlePostId(requestPost).then(function (result2){
            console.log(result2);
            //TODO Implement Disable method on page_id
          });
        }
      });
    }

    $scope.getPageAccessToken = function(){
      articleServices.getPageAccessToken($scope.wahigaFacebookPageId).then(function (response){
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
      request.message = $scope.article.facebook_message;
      request.link = "https://www.wahiga.com/News/"+$scope.article.friendly_url;
      request.name = $scope.article.facebook_title;
      request.picture = "https://www.wahiga.com/"+$scope.article.facebook_picture;
      request.pageId = $scope.wahigaFacebookPageId;
      request.description = $scope.article.preview;
      return request;
    }

    $window.fbAsyncInit = function() {
      console.log('teste');
      FB.init({ 
        appId: '1735599803381451', //facebook appId
        status: true, 
        cookie: true, 
        xfbml: true,
        version: 'v2.4'
      });

      $scope.getFacebookLoginStatus();
    }

}])
.controller('all-articles-controller', ['articleServices', '$scope', '$timeout', function(articleServices, $scope, $timeout) {

  $scope.articles = {};
  $scope.articleServices = articleServices;  
  $scope.totalOfArticles = 0;
  $scope.numberPerPage = 10;
  $scope.pageActual = 1;
  $scope.fieldToSearchScreen = "Title";
  $scope.totalOfPages = 1;
  $scope.blockPrevious = true;
  $scope.blockNext = false;
  $scope.lastActualPage = 1;
  $scope.showPagination = false;
  $scope.searchValue = "";
  $scope.fieldToSearch = "title";
  $scope.fieldsToSeach = ["Title", "User", "Status", "Friendly URL"];
  $scope.blockSearch = false;
  $scope.isSearch = false;

  $scope.getArticles = function(numberPerPage, pageNumber){
    $scope.articles = {};
    $scope.showPagination = false;
    if($scope.searchValue === ""){
      articleServices.getArticles(numberPerPage, pageNumber).then(function (result) {
        $scope.getTotalOfArticles(false);
        $scope.articles = result.data;
        $scope.showPagination = ($scope.totalOfPages > 1) ? true : false;
      });
    }else{
      $scope.isSearch = true;
      $scope.getTotalOfArticles(true);
      articleServices.searchArticlesByField(numberPerPage, pageNumber, $scope.fieldToSearch, $scope.searchValue).then(function (result) {
        $scope.articles = result.data;
        $scope.showPagination = ($scope.totalOfPages > 1) ? true : false;
      });
    }
    
  }

  $scope.getTotalOfArticles = function(search){
    if(!search){
      articleServices.getTotalOfArticles().then(function (result) {
        $scope.totalOfArticles = result.data;
        $scope.setTotalOfPages();
      });  
    }else{
      articleServices.getTotalOfArticlesSearch($scope.fieldToSearch, $scope.searchValue).then(function (result) {
        $scope.totalOfArticles = result.data;
        $scope.setTotalOfPages();
      });
    }
     
  }

  $scope.setTotalOfPages = function(){
    $scope.totalOfPages = ($scope.totalOfArticles > $scope.numberPerPage) ? parseInt(Math.ceil($scope.totalOfArticles/$scope.numberPerPage)) : 1;
    $scope.showPagination = ($scope.totalOfPages > 1) ? true : false;
  }

  $scope.goToPage = function(pageNum){
    $scope.blockSearch = false;
    if(typeof pageNum != "undefined" && pageNum != null){
      if(pageNum >= $scope.totalOfPages){
        $scope.pageActual = $scope.totalOfPages;
        $scope.blockPrevious = false;
        $scope.blockNext = true;
      }else if (pageNum <= 1){
        $scope.pageActual = 1;
        $scope.blockPrevious = true;
        $scope.blockNext = false;
      }else{
        $scope.pageActual = pageNum;
        $scope.blockPrevious = false;
        $scope.blockNext = false;
      }
    }else{
      $scope.pageActual = 1;
      $scope.blockPrevious = true;
      $scope.blockNext = false;
    }

    if($scope.lastActualPage != $scope.pageActual){
      $scope.lastActualPage = $scope.pageActual;
      $scope.getArticles($scope.numberPerPage, $scope.pageActual);
    }
  }

  $scope.goToSearch = function(){
    $scope.blockSearch = false;
    if($scope.pageActual >= $scope.totalOfPages){
      $scope.blockPrevious = false;
      $scope.blockNext = true;
    }else if ($scope.pageActual <= 1){
      $scope.blockPrevious = true;
      $scope.blockNext = false;
    }else{
      $scope.blockPrevious = false;
      $scope.blockNext = false;
    }
    if($scope.searchValue != ""){
      $scope.getArticles($scope.numberPerPage, 1);
    }else if($scope.searchValue === "" && $scope.isSearch){
      $scope.clearSearch();
    }  
  }

  $scope.clickGoToSearch = function(){
    if(!$scope.blockSearch){
      $scope.goToSearch();
    }
  }

  $scope.keyPress = function($event){
    if($event.keyCode === 13){
      $event.preventDefault();
      $timeout(function () { $event.target.blur() }, 0, false);
    }
  }

  $scope.focusToPage = function(){
    $scope.blockNext = true;
    $scope.blockPrevious = true;
    $scope.blockSearch = true;
  }

  $scope.prevPage = function(actualPage){
    if(!$scope.blockPrevious){
      actualPage = parseInt(actualPage) - 1;
      $scope.goToPage(actualPage); 
    }  
  }

  $scope.nextPage = function(actualPage){
    if(!$scope.blockNext){
      actualPage = parseInt(actualPage) + 1;
      $scope.goToPage(actualPage);
    }
  }

  $scope.setFieldToSearch = function(value){
    $scope.fieldToSearchScreen = value;
    if(value === "Title"){
      $scope.fieldToSearch = "title";
    }else if (value === "User"){
      $scope.fieldToSearch = "created_by_name";
    }else if (value === "Status"){
      $scope.fieldToSearch = "status";
    }else if (value === "Friendly URL"){
      $scope.fieldToSearch = "friendly_url";
    }
  }

  $scope.clearSearch = function(){
    $scope.isSearch = false;
    $scope.searchValue = "";
    $scope.getArticles($scope.numberPerPage, 1);
  }

  $scope.getArticles($scope.numberPerPage, $scope.pageActual);


}])

.controller('new-article-controller', ['articleServices', '$scope', '$timeout', 'Upload', '$q', '$interval', function(articleServices, $scope, $timeout, Upload, $q, $interval) {
  var plat = [];
  if(document.getElementById('hidden_article_platforms') != null){
    for(var i=0; i < document.getElementById('hidden_article_platforms').value.split(',').length; i++){
      plat.push(document.getElementById('hidden_article_platforms').value.split(',')[i]);
    }
  }
  var filesEdit = [];
  if(document.getElementById('hidden_article_files') != null && document.getElementById('hidden_article_files').value != ""){
    var filesJson = JSON.parse(document.getElementById('hidden_article_files').value);
    for(var i=0; i < filesJson.length; i++){
      filesEdit.push(filesJson[i]);
    }
  }
  $scope.isEdit = (typeof document.getElementById('hidden_article_id') != "undefined" && document.getElementById('hidden_article_id') != null ) ? true : false;
  $scope.article = {
    id: (typeof document.getElementById('hidden_article_id') != "undefined" && document.getElementById('hidden_article_id') != null) ? document.getElementById('hidden_article_id').value : '',
    title: {
      value: (typeof document.getElementById('hidden_article_title') != "undefined" && document.getElementById('hidden_article_title') != null) ? document.getElementById('hidden_article_title').value : '',
      errorCode: ''
    },
    subtitle: {
      value: (typeof document.getElementById('hidden_article_subtitle') != "undefined" && document.getElementById('hidden_article_subtitle') != null) ? document.getElementById('hidden_article_subtitle').value : '',
      errorCode: ''
    },
    preview: {
      value: (typeof document.getElementById('hidden_article_preview') != "undefined" && document.getElementById('hidden_article_preview') != null) ? document.getElementById('hidden_article_preview').value : '',
      errorCode: ''
    },
    friendly_url: {
      value: (typeof document.getElementById('hidden_article_friendly_url') != "undefined" && document.getElementById('hidden_article_friendly_url') != null) ? document.getElementById('hidden_article_friendly_url').value : '',
      errorCode: ''
    },
    is_highlighted: (typeof document.getElementById('hidden_article_is_highlighted') != "undefined" && document.getElementById('hidden_article_is_highlighted') != null) ? ((document.getElementById('hidden_article_is_highlighted').value == "true") ? true : false) : false,
    body: {
      value: (typeof document.getElementById('hidden_article_body') != "undefined" && document.getElementById('hidden_article_body') != null) ? document.getElementById('hidden_article_body').value : '',
      errorCode: ''
    },
    platforms: {
      value: plat,
      errorCode: ''
    },
    tags: {
      value: (typeof document.getElementById('hidden_article_tags') != "undefined" && document.getElementById('hidden_article_tags') != null) ? document.getElementById('hidden_article_tags').value : '',
      errorCode: ''
    },
    files: filesEdit,
    type: (typeof document.getElementById('article_type') != "undefined" && document.getElementById('article_type') != null) ? document.getElementById('article_type').value : '',
    stage: (typeof document.getElementById('hidden_article_id') != "undefined" && document.getElementById('hidden_article_id') != null) ? 2 : 1
  }

  $scope.filePosition = $scope.article.files.length;
  $scope.files = [];
  $scope.uploadErrorMessage = "";

  var friendly_url_pattern = new RegExp("^\\S+\\w{8,32}\\S{1,}");
  $scope.isSubmitting = false;

  $scope.focusField = function(field){
    switch(field) {
        case 'title':
            $scope.article.title.errorCode = '';
            break;
        case 'subtitle':
            $scope.article.subtitle.errorCode = '';
            break;
        case 'preview':
            $scope.article.preview.errorCode = '';
            break;
        case 'friendly_url':
            $scope.article.friendly_url.errorCode = '';
            break;
        case 'tags':
            $scope.article.tags.errorCode = '';
            break;
        default:   
    }
  }

  $scope.getErrorByCode = function(code, field){
    switch(code) {
        case '1':
            return 'Required field';
            break;
        case '2':
            return $scope.getPatternMessage(field);
            break;
        case '3':
          return 'Friendly URL is already registered by another article, please choose another'
        default:   
    }
  }

  $scope.next = function(){
    $scope.isSubmitting = true;
    switch($scope.article.stage) {
        case 1:
            $scope.isSubmitting = false;
            $scope.article.stage++;
            break;
        case 2:
            $scope.article.tags.errorCode = '';
            if($scope.article.type === "News"){
              if($scope.newsValidation()){
                if($scope.article.id != ''){
                  var result = $scope.updateArticle();
                   if(result){
                    $scope.article.stage++;
                  }
                }else{
                  var result = $scope.createArticle();
                  if(result){
                    $scope.article.stage++;
                  }
                }
              }
            }
            $scope.isSubmitting = false;
            break;
        case 3:
            $scope.uploadErrorMessage = "";
            var response = $scope.validateUploadFiles();
            if(response === true){
              $scope.uploadFilesToServer();
            }else{
              $scope.isSubmitting = false; 
            }
          break;
        default:  
    }
  }

  $scope.createImageModalContent = function(){
    $("#modal-container-images").empty();
    var html = "";
    angular.forEach($scope.article.files, function(f){
      console.log('ID ' + f.id);
      console.log('TYPE ' + f.type);
      if(f.id != '' && f.type === "Body"){
        html+= '<div class="col-lg-4" style="margin-bottom: 20px;">';
        html+= '<div style="background-image: url(\'/images/show_image/'+f.id+'\'); height: 100px; width: 100%; background-size: cover; background-repeat: no-repeat; background-position: center;" onclick="selectImage('+f.id+');"><div id="inside-'+f.id+'"></div></div>';
        html+= '</div>';
      }
    })
    console.log(html);
    $("#modal-container-images").append(html);
      
  }
    

  $scope.validateUploadFiles = function(){
    var valid = true;
    var headerCount = 0;
    var thumbCount = 0;
    var bodyCount = 0;
    var sliderCount = 0;
    angular.forEach($scope.article.files, function(f){
      if(f.type === "Header"){
        headerCount++;
      }
      if(f.type === "Thumb"){
        thumbCount++;
      }
      if(f.type === "Body"){
        bodyCount++;
      }
      if(f.type === "Slider"){
        sliderCount++;
      }
    });

    if(headerCount > 1){
      $scope.uploadErrorMessage = 'You must upload only one image with "Header" type';
      valid = false;
    }else if(thumbCount > 1){
      $scope.uploadErrorMessage = 'You must upload only one image with "Thumb" type';
      valid = false;
    }else if(thumbCount === 0){
      $scope.uploadErrorMessage = 'You must upload at least one image with "Thumb" type';
      valid = false;
    }else if(bodyCount === 0){
      $scope.uploadErrorMessage = 'You must upload at least one image with "Body" type';
      valid = false;
    }

    return valid;
  }

  $scope.uploadFilesToServer = function(){
    var finishCount = 0;
    var sendCount = 0;
    angular.forEach($scope.article.files, function(f){
      if(f.id === ''){
        sendCount++;
        f.upload = Upload.upload({
            url: '/private/articles/upload_files_service.json',
            data: {file: f},
            headers: {'Content-Type': 'application/json', 'X-CSRF-Token': $('meta[name=csrf-token]').attr('content')}

          });
          f.progress = 10;
          f.upload.then(function (response) {
              f.progress = 100;
              f.id = response.data[0].documentId;
              finishCount++;
              if(sendCount === finishCount){
                $scope.createImageModalContent();
                $scope.isSubmitting = false;  
                $scope.article.stage++;
              }
          }, function (response){
            if (response.status > 0){
              $scope.errorMsg = response.status + ': ' + response.data;
            }
            finishCount++;
          }, function(evt){
            f.progress = Math.min(100, parseInt(100.0 * evt.loaded / evt.total));        
        });
      }
    });

    if(sendCount === 0){
      $scope.isSubmitting = false;  
      $scope.article.stage++;
    }
  }

  $scope.createArticle = function(){
    var request = $scope.createArticleRequest();
    var result = articleServices.createArticle(request).then(function (result) {
        if(!result.data[0].isSuccessful){
          if(result.data[0].errorMessage === "Friendly url Friendly URL is already registered by another article, please choose another"){
            $scope.article.friendly_url.errorCode = '3';
          }
          return false;
        }else{
          $scope.article.id = result.data[0].articleid;
          return true;
        }
      });

    return result;
  }

  $scope.createArticleRequest = function(){
    var platforms = '';
    for(var i=0; i < $scope.article.platforms.value.length; i++){ 
      platforms += (platforms === '') ? $scope.article.platforms.value[i] : ','+$scope.article.platforms.value[i];
    }
    var request = {
        title: $scope.article.title.value,
        subtitle: $scope.article.subtitle.value,
        preview: $scope.article.preview.value,
        friendly_url: $scope.article.friendly_url.value,
        article_type: $scope.article.type,
        is_highlight: $scope.article.is_highlighted,
        tags: document.getElementById('article_tags').value,
        platform: platforms
    }
    console.log(request);

    return request;
  }

  $scope.updateArticle = function(){
    var request = $scope.updateArticleRequest();
    console.log('request ' + JSON.stringify(request));
    var result = articleServices.updateArticle(request).then(function (result) {
        if(!result.data[0].isSuccessful){
          if(result.data[0].errorMessage === "Friendly url Friendly URL is already registered by another article, please choose another"){
            $scope.article.friendly_url.errorCode = '3';
          }
          return false;
        }else{
          return true;
        }
      });
    return result;
  }

  $scope.updateArticleRequest = function(){
    var platforms = '';
    for(var i=0; i < $scope.article.platforms.value.length; i++){ 
      platforms += (platforms === '') ? $scope.article.platforms.value[i] : ','+$scope.article.platforms.value[i];
    }
    var request = {
        id: $scope.article.id,
        title: $scope.article.title.value,
        subtitle: $scope.article.subtitle.value,
        preview: $scope.article.preview.value,
        friendly_url: $scope.article.friendly_url.value,
        article_type: $scope.article.type,
        is_highlight: $scope.article.is_highlighted,
        body: $scope.article.body.value,
        tags: document.getElementById('article_tags').value,
        platform: platforms
    }
    console.log(request);
    return request;
  }

  $scope.newsValidation = function(){
    var valid = true;
    if($scope.article.title.value === ""){
      $scope.article.title.errorCode = '1';
      valid = false;
    }
    if($scope.article.subtitle.value === ""){
      $scope.article.subtitle.errorCode = '1';
      valid = false;
    }
    if($scope.article.friendly_url.value === ""){
      $scope.article.friendly_url.errorCode = '1';
      valid = false;
    }
    if($scope.article.preview.value === ""){
      $scope.article.preview.errorCode = '1';
      valid = false;
    }
    if($scope.article.platforms.value === ""){
      $scope.article.platforms.errorCode = '1';
      valid = false;
    }
    if(document.getElementById('article_tags').value === ""){
      $scope.article.tags.errorCode = '1';
      valid = false; 
    }
    if(!friendly_url_pattern.test($scope.article.friendly_url.value)){
      $scope.article.friendly_url.errorCode = '2';
      valid = false;
    }
    

    return valid;
  }

  $scope.getPatternMessage = function(field){
    switch(field) {
        case 'friendly_url':
            return 'This field must contains at least 8 characters, max 32, do not have any white space and do not cotains special characters only Underscore is permited';
            break;
        default:   
    }
  }

  $scope.previous = function(){
    $scope.article.stage--;
  }

  $scope.finish = function(){
    var textareaValue = $('#summernote').summernote('code');
    console.log(textareaValue);
    if(textareaValue === ""){
      $scope.article.body.errorCode = '1';
    }else{
      $scope.article.body.value = textareaValue;
      var result = $scope.updateArticle();
      if(result){
        window.location.href = "/private/articles/show/"+$scope.article.id;
      }
    }
  }

  $scope.changePickListValue = function(field){
    switch(field) {
        case 'platforms':
            $scope.article.platforms.errorCode = '';
            break;
        case 'tags':
            $scope.article.tags.errorCode = '';
            break;
        default:   
    }
  }

  $scope.uploadFiles = function(files, errFiles){
    angular.forEach(files, function(filaUploaded){
      $scope.article.files.push({id: '', name: filaUploaded.name, articleId: $scope.article.id, type: 'Body', file: filaUploaded, position: $scope.filePosition, progress: 0});
      $scope.filePosition++;
    })

  }

  $scope.deleteFile = function(position){
    var filePosition = null;
    var haveId = false;
    for(var i=0; i < $scope.article.files.length; i++){
      if($scope.article.files[i].position === position){
        if($scope.article.files[i].id != ''){
          haveId = true;
        }
        filePosition = i;
        break;
      }
    }
    if(haveId){
      $scope.article.files[filePosition].progress = 10;
      articleServices.deleteFile($scope.article.files[filePosition].id).then(function (result) {
        $scope.article.files.splice(filePosition, 1);    
      });
    }else{
      $scope.article.files.splice(filePosition, 1);
    }
  }

  
  if(typeof document.getElementById('hidden_article_body') != "undefined" && document.getElementById('hidden_article_body') != null){
    console.log(document.getElementById('hidden_article_body').value);
    var html = document.getElementById('hidden_article_body').value;
    $("#summernote").summernote({height: 800});
    $("#summernote").summernote("code", html);
    $scope.createImageModalContent();
  }

}]);