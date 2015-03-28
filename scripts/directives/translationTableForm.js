angular.module('ngs.i18nManage.demo')
.directive('translationTableForm', function() {
  return {
    scope: {
      key: '=key',
      value: '=value',
    },
    transclude: true,
    replace: true,
    templateUrl: 'directives/translationTable/form.html',
    controller: function($rootScope, $scope, i18nManager) {
      $rootScope.$on('$translateChangeSuccess', function() {
        $scope.diff = i18nManager.hasDiff($scope.key);
      });
      $scope.submitI18n = function($event) {
        $event.preventDefault();
        $scope.requesting = true;
        i18nManager.send($scope.key, $scope.value)
        .success(function(data, status, headers, config) {
          $scope.requesting = false;
          $scope.editing = false;
        })
        .error(function(data, status, headers, config) {
          $scope.requesting = false;
        });
      }
    }
  }
});

