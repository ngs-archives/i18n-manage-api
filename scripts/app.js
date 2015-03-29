angular.module('ngs.i18nManage.demo', [
  'pascalprecht.translate',
  'ui.bootstrap',
  'ngSanitize'
])
.run(function($rootScope, $compile, $translate, $sanitize) {
  $rootScope.handleMouseDown = function(e) {
    if(!e.altKey) return;
    var element = angular.element(e.srcElement)
      , key = element.attr('translate')
      , form, $scope
      ;
    if(!key || element[0].querySelector('[translation-table-form]'))
      return;
    element.html('');
    $scope = $rootScope.$new();
    $scope.key = $translate.use() + '.' + key;
    $scope.editing = true;
    $scope.value = $translate.instant(key);
    form = $compile('<div translation-table-form>')($scope);
    element.append(form);
  }
});
