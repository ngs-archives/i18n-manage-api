angular.module('ngs.i18nManage.demo')
.controller('TranslationTableController', function($scope, i18nManager, $location) {
  $scope.path = '/translations';
  $scope.isDefault = $location.path() == $scope.path;
  $scope.onTabSelect = function() { $location.path($scope.path) }
  $scope.translations = i18nManager.translations()
  $scope.languages = i18nManager.languages()
  $scope.keys = i18nManager.keys()
  $scope.showDiffs = false;
});

