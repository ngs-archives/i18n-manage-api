angular.module('ngs.i18nManage.demo')
.factory('GitHub', function GitHubFactory($http) {
  var apiBaseURL = 'https://api.github.com';

  function Client(token) {
    this.token = token;
  }

  Client.prototype.request = function(method, path, data) {
    var headers = {};
    if(this.token)
      headers['Authorization'] = 'token ' + this.token
    return $http({
      method: method,
      url: apiBaseURL + path,
      data: data,
      headers: headers
    })
  };

  Client.prototype.post = function(path, data) {
    return this.request('POST', path, data)
  };

  Client.prototype.get = function(path, data) {
    return this.request('GET', path, null)
  };

  return Client
});

