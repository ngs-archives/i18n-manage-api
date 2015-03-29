angular.module('ngs.i18nManage.demo')
.directive('translationTableForm', function() {
  return {
    transclude: true,
    replace: false,
    templateUrl: 'directives/translationTable/form.html',
    controller: function($rootScope, $scope, i18nManager, $translate) {
      $rootScope.$on('$translateChangeSuccess', function() {
        $scope.diff = i18nManager.hasDiff($scope.key);
        $scope.value = $translate.instant($scope.key.replace(/^[^\.]+\./, ''));
      });
      $scope.startEditing = function($event) {
        if($event.altKey || !$scope.inline) {
          $scope.editing = true;
        }
      };
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
    },
    link: function(scope, elm, attrs) {
      if(attrs.key)
        scope.key = attrs.key;
      if(attrs.value)
        scope.value = attrs.value;
    }
  }
});

