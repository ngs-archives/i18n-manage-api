angular.module('ngs.i18nManage.demo')
.controller('IntroductionController', function($scope, $location) {
  $scope.onTabSelect = function() { $location.path('/') }
});

