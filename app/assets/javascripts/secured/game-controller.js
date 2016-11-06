'use strict';

angular.module('admin-module.game-controller', ['ngFileUpload'])

.controller('all-games-controller', ['gameServices', '$scope', '$timeout', function(gameServices, $scope, $timeout) {

  $scope.games = {};
  $scope.gameServices = gameServices;  
  $scope.totalOfGames = 0;
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
  $scope.fieldsToSeach = ["Name", "Platforms", "Wahiga Rating", "User Rating", "Genres"];
  $scope.blockSearch = false;
  $scope.isSearch = false;

  $scope.getGames = function(numberPerPage, pageNumber){
    $scope.games = {};
    $scope.showPagination = false;
    if($scope.searchValue === ""){
      gameServices.getGames(numberPerPage, pageNumber).then(function (result) {
        $scope.getTotalOfGames(false);
        $scope.games = result.data;
        $scope.showPagination = ($scope.totalOfPages > 1) ? true : false;
      });
    }else{
      $scope.isSearch = true;
      $scope.getTotalOfGames(true);
      gameServices.searchGamesByField(numberPerPage, pageNumber, $scope.fieldToSearch, $scope.searchValue).then(function (result) {
        $scope.games = result.data;
        $scope.showPagination = ($scope.totalOfPages > 1) ? true : false;
      });
    }
    
  }

  $scope.getTotalOfGames = function(search){
    if(!search){
      gameServices.getTotalOfGames().then(function (result) {
        $scope.totalOfGames = result.data;
        $scope.setTotalOfPages();
      });  
    }else{
      gameServices.getTotalOfGamesSearch($scope.fieldToSearch, $scope.searchValue).then(function (result) {
        $scope.totalOfGames = result.data;
        $scope.setTotalOfPages();
      });
    }
     
  }

  $scope.setTotalOfPages = function(){
    $scope.totalOfPages = ($scope.totalOfGames > $scope.numberPerPage) ? parseInt(Math.ceil($scope.totalOfGames/$scope.numberPerPage)) : 1;
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
      $scope.getGames($scope.numberPerPage, $scope.pageActual);
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
      $scope.getGames($scope.numberPerPage, 1);
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
    }else if (value === "Platforms"){
      $scope.fieldToSearch = "platform";
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
    $scope.getGames($scope.numberPerPage, 1);
  }

  $scope.getGames($scope.numberPerPage, $scope.pageActual);
}])

.controller('new-game-controller', ['gameServices', '$scope', '$timeout', 'Upload', '$q', '$interval', function(gameServices, $scope, $timeout, Upload, $q, $interval) {
  var plat = [];
  if(document.getElementById('hidden_game_platform') != null){
    for(var i=0; i < document.getElementById('hidden_game_platform').value.split(',').length; i++){
      plat.push(document.getElementById('hidden_game_platform').value.split(',')[i]);
    }
  }

  var gen = [];
  if(document.getElementById('hidden_game_genre') != null){
    for(var i=0; i < document.getElementById('hidden_game_genre').value.split(',').length; i++){
      gen.push(document.getElementById('hidden_game_genre').value.split(',')[i]);
    }
  }
  /* TODO  Game image
  var filesEdit = [];
  if(document.getElementById('hidden_article_files') != null && document.getElementById('hidden_article_files').value != ""){
    var filesJson = JSON.parse(document.getElementById('hidden_article_files').value);
    for(var i=0; i < filesJson.length; i++){
      filesEdit.push(filesJson[i]);
    }
  }*/
  $scope.isEdit = (typeof document.getElementById('hidden_game_id') != "undefined" && document.getElementById('hidden_game_id') != null ) ? true : false;
  $scope.game = {
    id: (typeof document.getElementById('hidden_game_id') != "undefined" && document.getElementById('hidden_game_id') != null) ? document.getElementById('hidden_game_id').value : '',
    name: {
      value: (typeof document.getElementById('hidden_game_name') != "undefined" && document.getElementById('hidden_game_name') != null) ? document.getElementById('hidden_game_name').value : '',
      errorCode: ''
    },
    game_url: {
      value: (typeof document.getElementById('hidden_game_url') != "undefined" && document.getElementById('hidden_game_url') != null) ? document.getElementById('hidden_game_url').value : '',
      errorCode: ''
    },
    release_date: {
      value: (typeof document.getElementById('hidden_game_release_date') != "undefined" && document.getElementById('hidden_game_release_date') != null) ? document.getElementById('hidden_game_release_date').value : '',
      errorCode: ''
    },
    platform: {
      value: plat,
      errorCode: ''
    },
    wahiga_rating: {
      value: (typeof document.getElementById('hidden_game_wahiga_rating') != "undefined" && document.getElementById('hidden_game_wahiga_rating') != null) ? document.getElementById('hidden_game_wahiga_rating').value : '',
      errorCode: ''
    },
    user_rating: {
      value: (typeof document.getElementById('hidden_game_user_rating') != "undefined" && document.getElementById('hidden_game_user_rating') != null) ? document.getElementById('hidden_game_user_rating').value : '',
      errorCode: ''
    },
    description: {
      value: (typeof document.getElementById('hidden_game_description') != "undefined" && document.getElementById('hidden_game_description') != null) ? document.getElementById('hidden_game_description').value : '',
      errorCode: ''
    },
    genre: {
      value: gen,
      errorCode: ''
    },
    file: null
  }

  $scope.onChangeName = function(name){
    name = name.toLowerCase();
    $scope.game.game_url.value = removerAcentos(name);
    $scope.game.game_url.value = $scope.game.game_url.value.replaceAll(" ","-");
    $scope.game.game_url.value = $scope.game.game_url.value.replaceAll("_","-");
    $scope.game.game_url.value = $scope.game.game_url.value.replaceAll("$","");
    $scope.game.game_url.value = $scope.game.game_url.value.replaceAll("&","");
    $scope.game.game_url.value = $scope.game.game_url.value.replaceAll(":","");
    $scope.game.game_url.value = $scope.game.game_url.value.replaceAll(";","");
    $scope.game.game_url.value = $scope.game.game_url.value.replaceAll(",","");
    $scope.game.game_url.value = $scope.game.game_url.value.replaceAll(".","");
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

  $scope.gameCompanies = [];

  if(typeof document.getElementById('hidden_game_companies') !== "undefined" && document.getElementById('hidden_game_companies') !== null && document.getElementById('hidden_game_companies').value !== ''){
    $scope.gameCompanies = JSON.parse(document.getElementById('hidden_game_companies').value);
  }

  $scope.companies = [];

  $scope.companies = JSON.parse((typeof document.getElementById('hidden_companies') !== "undefined" && document.getElementById('hidden_companies') !== null && document.getElementById('hidden_companies') !== '') ? document.getElementById('hidden_companies').value : '');

  $scope.isSubmitting = false;
  $scope.game.stage = 1;

  $scope.focusField = function(field){
    switch(field) {
        case 'name':
            $scope.game.name.errorCode = '';
            break;
        case 'release_date':
            $scope.game.release_date.errorCode = '';
            break;
        case 'platform':
            $scope.game.platform.errorCode = '';
            break;
        case 'wahiga_rating':
            $scope.game.wahiga_rating.errorCode = '';
            break;
        case 'user_rating':
            $scope.game.user_rating.errorCode = '';
            break;
        case 'description':
            $scope.game.description.errorCode = '';
            break;
        case 'genre':
            $scope.game.genre.errorCode = '';
            break;    
        default:   
    }
  }

  $scope.createGameCompaniesRequest = function(){
    var request = {
      "game":{
        "id": $scope.game.id,
        "name": $scope.game.name.value,
        "game_companies_attributes": $scope.gameCompanies
      }
    };
    console.log('test');
    console.log(request);

    return request;
  }

  $scope.createGameCompanies = function(){
    var request = $scope.createGameCompaniesRequest();
    var result = gameServices.createGameCompanies(request).then(function (result) {
        if(!result.data[0].isSuccessful){
          //return false;
          return result;
        }else{
          $scope.game.id = result.data[0].gameid;

          //return true;
          return result;
        }
      });

    return result;
  }

  $scope.destroyGameCompanyRequest = function(id){
    var request = {
      "id": id  
    };

    return request;
  }

  $scope.destroyGameCompany = function(index){
    var gameCompany = $scope.gameCompanies[index];

    if(gameCompany.id !== null && gameCompany.id !== undefined && gameCompany.id !== ''){
      var request = $scope.destroyGameCompanyRequest(gameCompany.id);

      var result = gameServices.destroyGameCompany(request).then(function (result) {
        if(!result.data[0].isSuccessful){
          return result;
        }else{
          $scope.gameCompanies.splice(index, 1);
          return result;
        }
      });

      return result;
    }else{ 
      $scope.gameCompanies.splice(index, 1);
    }
  }

  $scope.newGameCompany = function(){
    var gameCompany = {
      id: '',
      game_id: $scope.game.id,
      company_id: '',
      company_type: 'Developer'
    };

    if($scope.gameCompanies === null || $scope.gameCompanies === ''){
      $scope.gameCompanies = [gameCompany];   
    }else{
      $scope.gameCompanies.push(gameCompany);
    }
  } 

  $scope.uploadFiles = function(file, errFiles){
    $scope.game.file = file[0];
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
    switch($scope.game.stage) {
        case 1:
            $scope.isSubmitting = false;
            $scope.game.stage++;
            break;
        case 2:
            if($scope.game.id != ''){
              var result = $scope.updateGame();
               if(result){
                $scope.game.stage++;
              }
            }else{
              var result = $scope.createGame();
              if(result){
                $scope.game.stage++;
              }
            }
            
            $scope.isSubmitting = false;
            break;
        default:  
    }
  }

  $scope.createGame = function(){
    var request = $scope.createGameRequest();
    var result = gameServices.createGame(request).then(function (result) {
        if(!result.data[0].isSuccessful){
          return false;
        }else{
          $scope.game.id = result.data[0].gameid;
          return true;
        }
      });

    return result;
  }

  $scope.createGameRequest = function(){
    var platforms = '';
    for(var i=0; i < $scope.game.platform.value.length; i++){ 
      platforms += (platforms === '') ? $scope.game.platform.value[i] : ','+$scope.game.platform.value[i];
    }
    var genres = '';
    for(var i=0; i < $scope.game.genre.value.length; i++){ 
      genres += (genres === '') ? $scope.game.genre.value[i] : ','+$scope.game.genre.value[i];
    }

    var request = {
        name: $scope.game.name.value,
        release_date: $scope.game.release_date.value,
        wahiga_rating: $scope.game.wahiga_rating.value,
        user_rating: $scope.game.user_rating.value,
        description: $scope.game.description.value,
        friendly_url: $scope.game.game_url.value,
        genre: genres,
        platform: platforms
    }
    console.log(request);

    return request;
  }

  $scope.updateGame = function(){
    var request = $scope.updateGameRequest();
    console.log('request ' + JSON.stringify(request));
    var result = gameServices.updateGame(request).then(function (result) {
        if(!result.data[0].isSuccessful){
          return false;
        }else{
          return true;
        }
      });
    return result;
  }

  $scope.updateGameRequest = function(){
    var platforms = '';
    for(var i=0; i < $scope.game.platform.value.length; i++){ 
      platforms += (platforms === '') ? $scope.game.platform.value[i] : ','+$scope.game.platform.value[i];
    }
    var genres = '';
    for(var i=0; i < $scope.game.genre.value.length; i++){ 
      genres += (genres === '') ? $scope.game.genre.value[i] : ','+$scope.game.genre.value[i];
    }

    var request = {
        id: $scope.game.id,
        name: $scope.game.name.value,
        release_date: $scope.game.release_date.value,
        wahiga_rating: $scope.game.wahiga_rating.value,
        user_rating: $scope.game.user_rating.value,
        friendly_url: $scope.game.game_url.value,
        description: $scope.game.description.value,
        genre: genres,
        platform: platforms
    }
    console.log(request);
    return request;
  }

  $scope.newsValidation = function(){
    var valid = true;
    if($scope.game.name.value === ""){
      $scope.game.name.errorCode = '1';
      valid = false;
    }
    if($scope.game.release_date.value === ""){
      $scope.game.release_date.errorCode = '1';
      valid = false;
    }
    /*if($scope.game.wahiga_rating.value === ""){
      $scope.game.wahiga_rating.errorCode = '1';
      valid = false;
    }
    if($scope.game.user_rating.value === ""){
      $scope.game.user_rating.errorCode = '1';
      valid = false;
    }*/
    if($scope.game.description.value === ""){
      $scope.game.description.errorCode = '1';
      valid = false;
    }
    if($scope.game.genre.value === ""){
      $scope.game.genre.errorCode = '1';
      valid = false;
    }

    return valid;
  }

  $scope.previous = function(){
    $scope.game.stage--;
  }

  $scope.finish = function(){
    var result = $scope.updateGame();
    if(result){
      var result2 = $scope.createGameCompanies();

      if(result2){
        if($scope.game.file !== null){
            $scope.game.file.upload = Upload.upload({
                    url: '/private/games/upload_game_image_service.json',
                    data: {file: $scope.game.file, game_id: $scope.game.id},
                    headers: {'Content-Type': 'application/json', 'X-CSRF-Token': $('meta[name=csrf-token]').attr('content')}
                });

                $scope.game.file.upload.then(function (response) {

                }, function (response){

                }, function(evt){
                    
                });
        }

        window.location.href = "/private/games/show/"+$scope.game.id;
      }
    }    
  }

  $scope.changePickListValue = function(field){
    switch(field) {
        case 'platform':
            $scope.game.platform.errorCode = '';
            break;
        case 'genre':
            $scope.game.genre.errorCode = '';
            break;    
        default:   
    }
  }
}]);