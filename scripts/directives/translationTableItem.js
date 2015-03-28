angular.module('ngs.i18nManage.demo')
.directive('translationTableItem', function() {
  return {
    scope: {
      key: '=key',
      languages: '=languages',
      translations: '=translations',
      showDiffs: '=showDiffs'
    },
    transclude: true,
    replace: true,
    templateUrl: 'directives/translationTable/item.html',
    controller: function($rootScope, $scope, i18nManager) {
      $rootScope.$on('$translateChangeSuccess', function() {
        $scope.diff = false;
        angular.forEach(i18nManager.languages(), function(lang) {
          $scope.diff = $scope.diff || i18nManager.hasDiff(lang + '.' + $scope.key);
        })
      });
    }
  }
});

