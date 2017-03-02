'use strict';

angular.module('admin-module.cinema-controller', ['ngFileUpload'])

.controller('all-cinemas-controller', ['cinemaServices', '$scope', '$timeout', function(cinemaServices, $scope, $timeout) {

  $scope.cinemas = {};
  $scope.cinemaServices = cinemaServices;  
  $scope.totalOfCinemas = 0;
  $scope.numberPerPage = 10;
  $scope.pageActual = 1;
  $scope.fieldToSearchScreen = "Name";
  $scope.totalOfPages = 1;
  $scope.blockPrevious = true;
  $scope.blockNext = false;
  $scope.lastActualPage = 1;
  $scope.showPagination = false;
  $scope.searchValue = "";
  $scope.fieldToSearch = "name";
  $scope.fieldsToSeach = ["Name", "Type", "Wahiga Rating", "User Rating", "Genres"];
  $scope.blockSearch = false;
  $scope.isSearch = false;

  $scope.getCinemas = function(numberPerPage, pageNumber){
    $scope.cinemas = {};
    $scope.showPagination = false;
    if($scope.searchValue === ""){
      cinemaServices.getCinemas(numberPerPage, pageNumber).then(function (result) {
        $scope.getTotalOfCinemas(false);
        $scope.cinemas = result.data;
        $scope.showPagination = ($scope.totalOfPages > 1) ? true : false;
      });
    }else{
      $scope.isSearch = true;
      $scope.getTotalOfCinemas(true);
      cinemaServices.searchCinemasByField(numberPerPage, pageNumber, $scope.fieldToSearch, $scope.searchValue).then(function (result) {
        $scope.cinemas = result.data;
        $scope.showPagination = ($scope.totalOfPages > 1) ? true : false;
      });
    }
    
  }

  $scope.getTotalOfCinemas = function(search){
    if(!search){
      cinemaServices.getTotalOfCinemas().then(function (result) {
        $scope.totalOfCinemas = result.data;
        $scope.setTotalOfPages();
      });  
    }else{
      cinemaServices.getTotalOfCinemasSearch($scope.fieldToSearch, $scope.searchValue).then(function (result) {
        $scope.totalOfCinemas = result.data;
        $scope.setTotalOfPages();
      });
    }
     
  }

  $scope.setTotalOfPages = function(){
    $scope.totalOfPages = ($scope.totalOfCinemas > $scope.numberPerPage) ? parseInt(Math.ceil($scope.totalOfCinemas/$scope.numberPerPage)) : 1;
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
      $scope.getCinemas($scope.numberPerPage, $scope.pageActual);
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
      $scope.getCinemas($scope.numberPerPage, 1);
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
    
    if(value === "Name"){
      $scope.fieldToSearch = "name";
    }else if (value === "Type"){
      $scope.fieldToSearch = "type";
    }else if (value === "Wahiga Rating"){
      $scope.fieldToSearch = "wahiga_rating";
    }else if (value === "User Rating"){
      $scope.fieldToSearch = "user_rating";
    }else if (value === "Genres"){
      $scope.fieldToSearch = "genre";
    }
  }

  $scope.clearSearch = function(){
    $scope.isSearch = false;
    $scope.searchValue = "";
    $scope.getCinemas($scope.numberPerPage, 1);
  }

  $scope.getCinemas($scope.numberPerPage, $scope.pageActual);
}])

.controller('new-cinema-controller', ['cinemaServices', '$scope', '$timeout', 'Upload', '$q', '$interval', function(cinemaServices, $scope, $timeout, Upload, $q, $interval) {
  var gen = [];
  if(document.getElementById('hidden_cinema_genre') != null){
    for(var i=0; i < document.getElementById('hidden_cinema_genre').value.split(',').length; i++){
      gen.push(document.getElementById('hidden_cinema_genre').value.split(',')[i]);
    }
  }

  $scope.isEdit = (typeof document.getElementById('hidden_cinema_id') != "undefined" && document.getElementById('hidden_cinema_id') != null ) ? true : false;
  $scope.cinema = {
    id: (typeof document.getElementById('hidden_cinema_id') != "undefined" && document.getElementById('hidden_cinema_id') != null) ? document.getElementById('hidden_cinema_id').value : '',
    name: {
      value: (typeof document.getElementById('hidden_cinema_name') != "undefined" && document.getElementById('hidden_cinema_name') != null) ? document.getElementById('hidden_cinema_name').value : '',
      errorCode: ''
    },
    cinema_url: {
      value: (typeof document.getElementById('hidden_cinema_url') != "undefined" && document.getElementById('hidden_cinema_url') != null) ? document.getElementById('hidden_cinema_url').value : '',
      errorCode: ''
    },
    release_date: {
      value: (typeof document.getElementById('hidden_cinema_release_date') != "undefined" && document.getElementById('hidden_cinema_release_date') != null) ? document.getElementById('hidden_cinema_release_date').value : '',
      errorCode: ''
    },
    type: {
      value: (typeof document.getElementById('hidden_cinema_type') != "undefined" && document.getElementById('hidden_cinema_type') != null) ? document.getElementById('hidden_cinema_type').value : '',
      errorCode: ''
    },
    wahiga_rating: {
      value: (typeof document.getElementById('hidden_cinema_wahiga_rating') != "undefined" && document.getElementById('hidden_cinema_wahiga_rating') != null) ? document.getElementById('hidden_cinema_wahiga_rating').value : '',
      errorCode: ''
    },
    user_rating: {
      value: (typeof document.getElementById('hidden_cinema_user_rating') != "undefined" && document.getElementById('hidden_cinema_user_rating') != null) ? document.getElementById('hidden_cinema_user_rating').value : '',
      errorCode: ''
    },
    description: {
      value: (typeof document.getElementById('hidden_cinema_description') != "undefined" && document.getElementById('hidden_cinema_description') != null) ? document.getElementById('hidden_cinema_description').value : '',
      errorCode: ''
    },
    genre: {
      value: gen,
      errorCode: ''
    },
    trailer: {
      value: (typeof document.getElementById('hidden_cinema_trailer') != "undefined" && document.getElementById('hidden_cinema_trailer') != null) ? document.getElementById('hidden_cinema_trailer').value : '',
      errorCode: ''
    },
    file: null
  }

  $scope.onChangeName = function(name){
    name = name.toLowerCase();
    $scope.cinema.cinema_url.value = removerAcentos(name);
    $scope.cinema.cinema_url.value = $scope.cinema.cinema_url.value.replaceAll(" ","-");
    $scope.cinema.cinema_url.value = $scope.cinema.cinema_url.value.replaceAll("_","-");
    $scope.cinema.cinema_url.value = $scope.cinema.cinema_url.value.replaceAll("$","");
    $scope.cinema.cinema_url.value = $scope.cinema.cinema_url.value.replaceAll("&","");
    $scope.cinema.cinema_url.value = $scope.cinema.cinema_url.value.replaceAll(":","");
    $scope.cinema.cinema_url.value = $scope.cinema.cinema_url.value.replaceAll(";","");
    $scope.cinema.cinema_url.value = $scope.cinema.cinema_url.value.replaceAll(",","");
    $scope.cinema.cinema_url.value = $scope.cinema.cinema_url.value.replaceAll(".","");
    $scope.cinema.cinema_url.value = $scope.cinema.cinema_url.value.replaceAll("'","");
    $scope.cinema.cinema_url.value = $scope.cinema.cinema_url.value.replaceAll("´","");
    $scope.cinema.cinema_url.value = $scope.cinema.cinema_url.value.replaceAll("`","");
    $scope.cinema.cinema_url.value = $scope.cinema.cinema_url.value.replaceAll("*","");
    $scope.cinema.cinema_url.value = $scope.cinema.cinema_url.value.replaceAll("(","");
    $scope.cinema.cinema_url.value = $scope.cinema.cinema_url.value.replaceAll(")","");
    $scope.cinema.cinema_url.value = $scope.cinema.cinema_url.value.replaceAll("?","");
    $scope.cinema.cinema_url.value = $scope.cinema.cinema_url.value.replaceAll("!","");
    $scope.cinema.cinema_url.value = $scope.cinema.cinema_url.value.replaceAll("/","");
  }

  String.prototype.replaceAll = function(de, para){
    var str = this;
    var pos = str.indexOf(de);
    while (pos > -1){
      str = str.replace(de, para);
      pos = str.indexOf(de);
    }
    return (str);
  }

  function removerAcentos( newStringComAcento ) {
    var string = newStringComAcento;
    var mapaAcentosHex  = {
      a : /[\xE0-\xE6]/g,
      e : /[\xE8-\xEB]/g,
      i : /[\xEC-\xEF]/g,
      o : /[\xF2-\xF6]/g,
      u : /[\xF9-\xFC]/g,
      c : /\xE7/g,
      n : /\xF1/g
    };

    for ( var letra in mapaAcentosHex ) {
      var expressaoRegular = mapaAcentosHex[letra];
      string = string.replace( expressaoRegular, letra );
    }

    return string;
  }

  $scope.cinemaCompanies = [];

  if(typeof document.getElementById('hidden_cinema_companies') !== "undefined" && document.getElementById('hidden_cinema_companies') !== null && document.getElementById('hidden_cinema_companies').value !== ''){
    $scope.cinemaCompanies = JSON.parse(document.getElementById('hidden_cinema_companies').value);
  }

  $scope.companies = [];

  $scope.companies = JSON.parse((typeof document.getElementById('hidden_companies') !== "undefined" && document.getElementById('hidden_companies') !== null && document.getElementById('hidden_companies') !== '') ? document.getElementById('hidden_companies').value : '');

  $scope.isSubmitting = false;
  $scope.cinema.stage = 1;

  $scope.focusField = function(field){
    switch(field) {
        case 'name':
            $scope.cinema.name.errorCode = '';
            break;
        case 'release_date':
            $scope.cinema.release_date.errorCode = '';
            break;
        case 'type':
            $scope.cinema.type.errorCode = '';
            break;
        case 'wahiga_rating':
            $scope.cinema.wahiga_rating.errorCode = '';
            break;
        case 'user_rating':
            $scope.cinema.user_rating.errorCode = '';
            break;
        case 'description':
            $scope.cinema.description.errorCode = '';
            break;
        case 'genre':
            $scope.cinema.genre.errorCode = '';
            break;
        case 'trailer':
            $scope.cinema.genre.errorCode = '';
            break;        
        default:   
    }
  }

  $scope.createCinemaCompaniesRequest = function(){
    var request = {
      "cinema":{
        "id": $scope.cinema.id,
        "name": $scope.cinema.name.value,
        "cinema_companies_attributes": $scope.cinemaCompanies
      }
    };
    console.log('test');
    console.log(request);

    return request;
  }

  $scope.createCinemaCompanies = function(){
    var request = $scope.createCinemaCompaniesRequest();
    var result = cinemaServices.createCinemaCompanies(request).then(function (result) {
        if(!result.data[0].isSuccessful){
          //return false;
          return result;
        }else{
          $scope.cinema.id = result.data[0].cinemaid;

          //return true;
          return result;
        }
      });

    return result;
  }

  $scope.destroyCinemaCompanyRequest = function(id){
    var request = {
      "id": id  
    };

    return request;
  }

  $scope.destroyCinemaCompany = function(index){
    var cinemaCompany = $scope.cinemaCompanies[index];

    if(cinemaCompany.id !== null && cinemaCompany.id !== undefined && cinemaCompany.id !== ''){
      var request = $scope.destroyCinemaCompanyRequest(cinemaCompany.id);

      var result = cinemaServices.destroyCinemaCompany(request).then(function (result) {
        if(!result.data[0].isSuccessful){
          return result;
        }else{
          $scope.cinemaCompanies.splice(index, 1);
          return result;
        }
      });

      return result;
    }else{ 
      $scope.cinemaCompanies.splice(index, 1);
    }
  }

  $scope.newCinemaCompany = function(){
    var cinemaCompany = {
      id: '',
      cinema_id: $scope.cinema.id,
      company_id: '',
      company_type: 'Developer'
    };

    if($scope.cinemaCompanies === null || $scope.cinemaCompanies === ''){
      $scope.cinemaCompanies = [cinemaCompany];   
    }else{
      $scope.cinemaCompanies.push(cinemaCompany);
    }
  } 

  $scope.uploadFiles = function(file, errFiles){
    $scope.cinema.file = file[0];
  }

  $scope.getErrorByCode = function(code, field){
    switch(code) {
        case '1':
            return 'Required field';
            break;
        case '2':
            return $scope.getPatternMessage(field);
            break;
        default:   
    }
  }

  $scope.next = function(){
    $scope.isSubmitting = true;
    switch($scope.cinema.stage) {
        case 1:
            $scope.isSubmitting = false;
            $scope.cinema.stage++;
            break;
        case 2:
            if($scope.cinema.id != ''){
              var result = $scope.updateCinema();
               if(result){
                $scope.cinema.stage++;
              }
            }else{
              var result = $scope.createCinema();
              if(result){
                $scope.cinema.stage++;
              }
            }
            
            $scope.isSubmitting = false;
            break;
        default:  
    }
  }

  $scope.createCinema = function(){
    var request = $scope.createCinemaRequest();
    var result = cinemaServices.createCinema(request).then(function (result) {
        if(!result.data[0].isSuccessful){
          return false;
        }else{
          $scope.cinema.id = result.data[0].cinemaid;
          return true;
        }
      });

    return result;
  }

  $scope.createCinemaRequest = function(){
    var genres = '';
    for(var i=0; i < $scope.cinema.genre.value.length; i++){ 
      genres += (genres === '') ? $scope.cinema.genre.value[i] : ','+$scope.cinema.genre.value[i];
    }

    var request = {
        name: $scope.cinema.name.value,
        release_date: $scope.cinema.release_date.value,
        wahiga_rating: $scope.cinema.wahiga_rating.value,
        user_rating: $scope.cinema.user_rating.value,
        description: $scope.cinema.description.value,
        friendly_url: $scope.cinema.cinema_url.value,
        trailer: $scope.cinema.trailer.value,
        genre: genres,
        cinema_type: $scope.cinema.type.value
    }
    console.log(request);

    return request;
  }

  $scope.updateCinema = function(){
    var request = $scope.updateCinemaRequest();
    console.log('request ' + JSON.stringify(request));
    var result = cinemaServices.updateCinema(request).then(function (result) {
        if(!result.data[0].isSuccessful){
          return false;
        }else{
          return true;
        }
      });
    return result;
  }

  $scope.updateCinemaRequest = function(){
    var genres = '';
    for(var i=0; i < $scope.cinema.genre.value.length; i++){ 
      genres += (genres === '') ? $scope.cinema.genre.value[i] : ','+$scope.cinema.genre.value[i];
    }

    var request = {
        id: $scope.cinema.id,
        name: $scope.cinema.name.value,
        release_date: $scope.cinema.release_date.value,
        wahiga_rating: $scope.cinema.wahiga_rating.value,
        user_rating: $scope.cinema.user_rating.value,
        friendly_url: $scope.cinema.cinema_url.value,
        description: $scope.cinema.description.value,
        trailer: $scope.cinema.trailer.value,
        genre: genres,
        cinema_type: $scope.cinema.type.value
    }
    console.log(request);
    return request;
  }

  $scope.newsValidation = function(){
    var valid = true;
    if($scope.cinema.name.value === ""){
      $scope.cinema.name.errorCode = '1';
      valid = false;
    }
    if($scope.cinema.release_date.value === ""){
      $scope.cinema.release_date.errorCode = '1';
      valid = false;
    }
    if($scope.cinema.description.value === ""){
      $scope.cinema.description.errorCode = '1';
      valid = false;
    }

    if($scope.cinema.genre.value === ""){
      $scope.cinema.genre.errorCode = '1';
      valid = false;
    }

    return valid;
  }

  $scope.previous = function(){
    $scope.cinema.stage--;
  }

  $scope.finish = function(){
    var result = $scope.updateCinema();
    if(result){
      var result2 = $scope.createCinemaCompanies();

      if(result2){
        if($scope.cinema.file !== null){
            $scope.cinema.file.upload = Upload.upload({
                    url: '/private/cinemas/upload_cinema_image_service.json',
                    data: {file: $scope.cinema.file, cinema_id: $scope.cinema.id},
                    headers: {'Content-Type': 'application/json', 'X-CSRF-Token': $('meta[name=csrf-token]').attr('content')}
                });

                $scope.cinema.file.upload.then(function (response) {

                }, function (response){

                }, function(evt){
                    
                });
        }

        window.location.href = "/private/cinemas/show/"+$scope.cinema.id;
      }
    }    
  }

  $scope.changePickListValue = function(field){
    switch(field) {
        case 'genre':
            $scope.cinema.genre.errorCode = '';
            break;    
        default:   
    }
  }
}]);