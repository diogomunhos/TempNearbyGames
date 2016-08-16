'use strict';

angular.module('admin-module.article-controller', ['ngFileUpload'])

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

.controller('new-article-controller', ['articleServices', '$scope', '$timeout', 'Upload', function(articleServices, $scope, $timeout, Upload) {
  
  $scope.article = {
    id: '72',
    title: {
      value: '',
      errorCode: ''
    },
    subtitle: {
      value: '',
      errorCode: ''
    },
    preview: {
      value: '',
      errorCode: ''
    },
    friendly_url: {
      value: '',
      errorCode: ''
    },
    is_highlighted: false,
    body: {
      value: '',
      errorCode: ''
    },
    platforms: {
      value: '',
      errorCode: ''
    },
    tags: {
      value: '',
      errorCode: ''
    },
    files:[],
    type: (typeof document.getElementById('article_type') != "undefined") ? document.getElementById('article_type').value : '',
    stage: 4
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
              $scope.isSubmitting = false;  
              $scope.article.stage++;
            }else{
              $scope.isSubmitting = false; 
            }
          break;
        default:  
    }
  }

  $scope.validateUploadFiles = function(){
    var valid = true;
    var headerCount = 0;
    var thumbCount = 0;
    var bodyCount = 0;
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
    });

    if(headerCount > 1){
      $scope.uploadErrorMessage = 'You must upload only one image with "Header" type';
      valid = false;
    }else if(headerCount === 0){
      $scope.uploadErrorMessage = 'You must upload at least one image with "Header" type';
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
    angular.forEach($scope.article.files, function(f){
      if(f.id === ''){
        f.upload = Upload.upload({
            url: '/private/articles/upload_files_service.json',
            data: {file: f},
            headers: {'Content-Type': 'application/json', 'X-CSRF-Token': $('meta[name=csrf-token]').attr('content')}

          });
          f.progress = 10;
          f.upload.then(function (response) {
            $timeout(function (){
              f.progress = 100;
              f.id = response.data[0].documentId;
            });

          }, function (response){
            if (response.status > 0){
              $scope.errorMsg = response.status + ': ' + response.data;
            }
          }, function(evt){
            f.progress = Math.min(100, parseInt(100.0 * evt.loaded / evt.total));        
        });
      }
    });
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
    var request = {
        title: $scope.article.title.value,
        subtitle: $scope.article.subtitle.value,
        preview: $scope.article.preview.value,
        friendly_url: $scope.article.friendly_url.value,
        article_type: $scope.article.type,
        is_highlight: $scope.article.is_highlighted,
        tags: document.getElementById('article_tags').value,
        platform: $scope.article.platforms.value
    }

    return request;
  }

  $scope.updateArticle = function(){
    var request = $scope.updateArticleRequest();
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
    var request = {
        id: $scope.article.id,
        title: $scope.article.title.value,
        subtitle: $scope.article.subtitle.value,
        preview: $scope.article.preview.value,
        friendly_url: $scope.article.friendly_url.value,
        article_type: $scope.article.type,
        is_highlight: $scope.article.is_highlighted,
        tags: document.getElementById('article_tags').value,
        platform: $scope.article.platforms.value
    }

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
      $scope.article.files.push({id: '', name: filaUploaded.name, articleId: $scope.article.id, type: 'Header', file: filaUploaded, position: $scope.filePosition, progress: 0});
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

}]);