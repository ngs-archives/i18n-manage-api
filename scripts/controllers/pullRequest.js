angular.module('ngs.i18nManage.demo')
.controller('PullRequestController', function($rootScope, $scope, $location, i18nManager, GitHub, $window) {
  var client = null, baseRepo = 'ngs/i18n-manage-api';

  function getForks() {
    client.get('/repos/'+ baseRepo +'/forks')
    .success(function(data, status, headers, config) {
      $scope.forkedLogins = [];
      $scope.forks = (angular.isArray(data) ? data : [])
      .filter(function(item, index) {
        if(item.permissions.push) {
          $scope.forkedLogins.push(item.owner.login);
          return true;
        }
        return false;
      });
    })
  }

  function getOrganizations() {
    client.get('/user/orgs')
    .success(function(data, status, headers, config) {
      $scope.orgs = data;
    })
  }

  function getInfo() {
    client.get('/user')
    .success(function(data, status, headers, config) {
      $scope.me = data;
    })
  }

  function createFork(login) {
    client.post('/repos/'+ baseRepo +'/forks', { organization: login })
    .success(function(data, status, headers, config) {
      $scope.forks.push(data);
      $scope.forkedLogins.push(login);
      setTimeout(function() {
        sendPullRequest(data);
      }, 100);
    });
  }

  function sendPullRequest(fork) {
    i18nManager.submit(baseRepo, fork)
    .success(function(data, status, headers, config) {
      $window.location.assign(data.url);
    });
  }

  $scope.path = '/pr';
  $scope.isDefault = $location.path() == $scope.path;
  $scope.onTabSelect = function() { $location.path($scope.path) }
  $scope.login = function() {
    i18nManager.login()
  };
  $scope.sendPullRequest = function(fork) {
    sendPullRequest(fork);
  };
  $scope.createFork = function(owner) {
    createFork(owner.login);
  };
  $scope.accessToken = null;
  i18nManager.auth()
  .success(function(data, status, headers, config) {
    $scope.accessToken = data.token;
    client = new GitHub(data.token);
    getForks();
    getInfo();
    getOrganizations();
  })
});

