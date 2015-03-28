angular.module('ngs.i18nManage.demo')
.controller('LanguageSwitchController', function(i18nManager, $translate, $scope) {
  $scope.languages = i18nManager.languages();
  $scope.changeLanguage = function(language) {
    $scope.currentLanguage = language;
    $translate.use(language);
  };
  $scope.changeLanguage('en');
});

