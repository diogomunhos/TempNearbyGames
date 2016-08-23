'use strict';

angular.module('admin-module.profile-controller', ['ngFileUpload'])

.controller('all-profiles-controller', ['profileServices', '$scope', '$timeout', function(profileServices, $scope, $timeout) {

	$scope.profiles = {};
	$scope.showPagination = false;
	$scope.totalOfPages = 1;
	$scope.numberPerPage = 25;
	$scope.totalOfProfiles = 0;
	$scope.lastActualPage = 1;
	$scope.actualPage
	$scope.blockPrevious = true;
	$scope.blockNext = false;




	$scope.getProfiles = function(numberPerPage, pageNumber){
		profileServices.getProfiles(numberPerPage, pageNumber).then(function (result) {
			$scope.getTotalOfProfiles();
			$scope.profiles = result.data;
			$scope.showPagination = ($scope.totalOfPages > 1) ? true : false;
		});
	}

	$scope.getTotalOfProfiles = function(){
		profileServices.getTotalOfProfiles().then(function (result) {
			$scope.totalOfProfiles = result.data;
			$scope.setTotalOfPages();
		}); 
	}

	$scope.setTotalOfPages = function(){
		$scope.totalOfPages = ($scope.totalOfProfiles > $scope.numberPerPage) ? parseInt(Math.ceil($scope.totalOfProfiles/$scope.numberPerPage)) : 1;
		$scope.showPagination = ($scope.totalOfPages > 1) ? true : false;
	}

	$scope.goToPage = function(pageNum){
		if(typeof pageNum != "undefined" && pageNum != null){
			if(pageNum >= $scope.totalOfPages){
				$scope.actualPage = $scope.totalOfPages;
				$scope.blockPrevious = false;
				$scope.blockNext = true;
			}else if (pageNum <= 1){
				$scope.actualPage = 1;
				$scope.blockPrevious = true;
				$scope.blockNext = false;
			}else{
				$scope.actualPage = pageNum;
				$scope.blockPrevious = false;
				$scope.blockNext = false;
			}
		}else{
			$scope.actualPage = 1;
			$scope.blockPrevious = true;
			$scope.blockNext = false;
		}

		if($scope.lastActualPage != $scope.actualPage){
			$scope.lastActualPage = $scope.actualPage;
			$scope.getProfiles($scope.numberPerPage, $scope.actualPage);
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


	$scope.getProfiles($scope.numberPerPage, 1);



}])
.controller('edit-my-profile-controller', ['profileServices', '$scope', 'Upload', function(profileServices, $scope, Upload) {

	$scope.profile = {
		first_name: {
			value: document.getElementById('profile[first_name]').value,
			errorCode: ''
		},
		last_name: {
			value: document.getElementById('profile[last_name]').value,
			errorCode: ''
		},
		nickname: {
			value: document.getElementById('profile[nickname]').value,
			errorCode: ''
		},
		about: {
			value: document.getElementById('profile[about]').innerHTML,
			errorCode: ''
		},
		facebook: {
			value: document.getElementById('profile[facebook]').value,
			errorCode: ''
		},
		twitter: {
			value: document.getElementById('profile[twitter]').value,
			errorCode: ''
		},
		instagram: {
			value: document.getElementById('profile[instagram]').value,
			errorCode: ''
		},
		file: null
	}

	$scope.focusField = function(field){
		switch(field) {
		    case 'first_name':
		        $scope.profile.first_name.errorCode = '';
		        break;
		    case 'last_name':
		        $scope.profile.last_name.errorCode = '';
		        break;
		    case 'nickname':
		        $scope.profile.nickname.errorCode = '';
		        break;
		    default:   
		}
	}

	$scope.saveProfile = function(){
		if($scope.validateProfile()){
			var request = $scope.createSaveProfileRequest();
			profileServices.saveProfile(request).then(function (result) {
				if(result.data[0].isSuccessful === true){
					if($scope.profile.file !== null){
						$scope.profile.file.upload = Upload.upload({
				            url: '/private/profiles/my-profile/upload_profile_image_service.json',
				            data: {file: $scope.profile.file},
				            headers: {'Content-Type': 'application/json', 'X-CSRF-Token': $('meta[name=csrf-token]').attr('content')}
				        });

				        $scope.profile.file.upload.then(function (response) {
				           window.location = "/private/profiles/my-profile"
				        }, function (response){

				        }, function(evt){
				            
				        });
					}else{
						window.location = "/private/profiles/my-profile"
					}
				}
			});	
		}
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

	$scope.validateProfile = function(){
		var valid = true;
	    if($scope.profile.first_name.value === ""){
	      $scope.profile.first_name.errorCode = '1';
	      valid = false;
	    }
	    if($scope.profile.last_name.value === ""){
	      $scope.profile.last_name.errorCode = '1';
	      valid = false;
	    }
	    if($scope.profile.nickname.value === ""){
	      $scope.profile.nickname.errorCode = '1';
	      valid = false;
	    }

	    return valid;
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

	$scope.createSaveProfileRequest = function(){
		return {
			first_name: $scope.profile.first_name.value,
			last_name: $scope.profile.last_name.value,
			nickname: $scope.profile.nickname.value,
			about: $scope.profile.about.value,
			facebook: $scope.profile.facebook.value,
			twitter: $scope.profile.twitter.value,
			instagram: $scope.profile.instagram.value
		}		
	}

	$scope.uploadFiles = function(file, errFiles){
	 	$scope.profile.file = file[0];   
    }

}]);