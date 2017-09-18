'use strict';

angular.module('admin-module.report-controller', [])

.controller('article-author-date-controller', ['reportServices', '$scope', function(reportServices, $scope) {

  $scope.reportResult = [];
  $scope.request = {
    startDate: new Date(),
    endDate: new Date(),
    authorName: "Diogo Munhos",
    status: "Draft"
  }

  $scope.refresh = function(){
    $scope.request.startDate.setDate($scope.request.startDate.getDate() - 1);
    $scope.request.endDate.setDate($scope.request.endDate.getDate() + 1);
    reportServices.getArticleAuthorDate($scope.request).then(function (result) {
      console.log('refresh ', result.data);
      if(result.data[0].isSuccessful === true){
        $('#reportTable').bootstrapTable('load',{
          data: result.data[0].rows
        });
      }
    });
  }

}]);
