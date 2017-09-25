'use strict';

angular.module('admin-module.report-controller', [])

.controller('article-author-date-controller', ['reportServices', '$scope', function(reportServices, $scope) {

  $scope.reportResult = [];
  $scope.request = {
    startDate: new Date(),
    endDate: new Date(),
    authorName: "",
    status: "Draft"
  }
  $scope.isSubmitting = false;

  $('#date-range .input-daterange').datepicker({
      format: "dd/mm/yyyy",
      todayBtn: "linked",
      autoclose: true,
      todayHighlight: true
  });

  $('#status-select').chosen();

  $scope.submit = function(){
    console.log($scope.request);
    console.log($('#status-select').val());
    if($scope.searchValidation() === true){
      $scope.request.startDate.setFullYear(($("#startDate").val()).split('/')[2], (parseInt(($("#startDate").val()).split('/')[1]) - 1), ($("#startDate").val()).split('/')[0])
      $scope.request.endDate.setFullYear(($("#endDate").val()).split('/')[2], (parseInt(($("#endDate").val()).split('/')[1]) - 1), ($("#endDate").val()).split('/')[0])
      $scope.request.status = $('#status-select').val();
      reportServices.getArticleAuthorDate($scope.request).then(function (result) {
        console.log('refresh ', result.data);
        if(result.data[0].isSuccessful === true){
          $('#reportTable').bootstrapTable('load',{
            data: result.data[0].rows
          });
        }
      });
    }
  }

  $scope.selectUser = function(id, name){
    $scope.request.authorName = name;
  }

  $scope.searchValidation = function(){
    var valid = true;
    if($("#startDate").val() === '' || $("#startDate").val().indexOf('/') === -1){
      valid = false;
    }
    if($("#endDate").val() === '' || $("#endDate").val().indexOf('/') === -1){
      valid = false;
    }
    if($scope.request.authorName === ''){
      valid = false;
    }
    if($('#status-select').val() === ''){
      valid = false;
    }

    return valid;
  }

}]);
