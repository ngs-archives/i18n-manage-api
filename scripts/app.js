angular.module('ngs.i18nManage.demo', [
  'pascalprecht.translate',
  'ui.bootstrap'
])
.run(function($rootScope, $compile, $translate, $window, i18nManager) {
  $rootScope.$on('$translateChangeSuccess', function() {
    $rootScope.diffCount = Object.keys(i18nManager.diff()).length;
    $rootScope.initialized = true;
  });
  $window.onkeydown = function handkeKeyDown(e) {
    var body = angular.element(document.body);
    if(e.which === 18)
      body.addClass('opt-hold');
  };
  $window.onkeyup = function handkeKeyUp(e) {
    var body = angular.element(document.body);
    body.removeClass('opt-hold');
  };
  $rootScope.handleMouseDown = function(e) {
    if(!e.altKey) return;
    var element = angular.element(e.srcElement)
      , key = element.attr('translate')
      , form, $scope
      ;
    if(!key || element[0].querySelector('[translation-table-form]'))
      return;
    e.preventDefault();
    element.html('');
    $scope = $rootScope.$new();
    $scope.key = $translate.use() + '.' + key;
    $scope.editing = true;
    $scope.value = $translate.instant(key);
    $scope.inline = true;
    form = $compile('<span translation-table-form>')($scope);
    element.append(form);
  }
});
