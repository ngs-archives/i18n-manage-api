+function() {

  var $translateProvider = null
    , defaultTranslationTable = null
    , defaultFlatTranslationTable = null
    , apiBaseURL =  'https://kz-i18n-manager.herokuapp.com'
    ;

  var NESTED_OBJECT_DELIMITER = '.';

  // from http://git.io/jEKU
  var flatObject = function (data, path, result, prevKey) {
    var key, keyWithPath, keyWithShortPath, val;

    if (!path) {
      path = [];
    }
    if (!result) {
      result = {};
    }
    for (key in data) {
      if (!Object.prototype.hasOwnProperty.call(data, key)) {
        continue;
      }
      val = data[key];
      if (angular.isObject(val)) {
        flatObject(val, path.concat(key), result, key);
      } else {
        keyWithPath = path.length ? ('' + path.join(NESTED_OBJECT_DELIMITER) + NESTED_OBJECT_DELIMITER + key) : key;
        if(path.length && key === prevKey){
          // Create shortcut path (foo.bar == foo.bar.bar)
          keyWithShortPath = '' + path.join(NESTED_OBJECT_DELIMITER);
          // Link it to original path
          result[keyWithShortPath] = '@:' + keyWithPath;
        }
        result[keyWithPath] = val;
      }
    }
    return result;
  };

  var unflatObject = function(obj) {
    var ret = {}, keys, k, i, cursor;
    for(k in obj) {
      keys = k.split(NESTED_OBJECT_DELIMITER);
      cursor = ret;
      for(i = 0; i < keys.length - 1; i++) {
        cursor = cursor[keys[i]] = cursor[keys[i]] || {};
      }
      cursor[keys[keys.length - 1]] = obj[k];
    }
    return ret;
  }

  angular.module('ngs.i18nManage.demo')
  .config(function(_$translateProvider_) {
    $translateProvider = _$translateProvider_;
    defaultFlatTranslationTable = flatObject($translateProvider.translations());
    defaultTranslationTable = unflatObject(defaultFlatTranslationTable);
  })
  .service('i18nManager', function I18nManagerService($rootScope, $http, $translate, $window, $location) {
    var diff = null;
    return {
      translations: function() {
        return $translateProvider.translations();
      },
      languages: function() {
        return Object.keys(this.translations())
      },
      keys: function() {
        var languages = this.languages()
          , translations = this.translations()
          , keys = []
        angular.forEach(languages, function (lang) {
          keys = keys.concat(Object.keys(translations[lang]));
        });
        keys = keys.filter(function(v, i){ return keys.indexOf(v) == i });
        return keys;
      },
      load: function() {
        var self = this;
        return self.request('GET', '/i18n')
        .success(function(data, status, headers, config) {
          self.importTranslations(data);
        })
      },
      importTranslations: function(data) {
        diff = flatObject(data || {});
        if(!data) data = defaultTranslationTable;
        angular.forEach(data, function (table, lang) {
          $translateProvider.translations(lang, table);
          $rootScope.$emit('$translateChangeSuccess', {language: lang});
        })
      },
      diff: function() {
        return diff || {};
      },
      hasDiff: function(key) {
        var d = this.diff()[key]
          , keys = key.split(NESTED_OBJECT_DELIMITER)
          , lang = keys.shift()
          ;
        return typeof d !== 'undefined' && defaultFlatTranslationTable[key] !== d
      },
      reset: function() {
        var self = this;
        return self.request('DELETE', '/')
        .success(function(data, status, headers, config) {
          self.importTranslations(null);
        })
      },
      send: function(key, value) {
        var self = this;
        return self.request('POST', '/i18n', { key: key, value: value })
        .success(function(data, status, headers, config) {
          self.importTranslations(data);
        })
      },
      auth: function() {
        return this.request('GET', '')
      },
      login: function() {
        $window.location.assign(apiBaseURL + '/login?returnUrl=' + encodeURIComponent($location.absUrl()));
      },
      submit: function(baseRepo, fork) {
        return this.request('POST', '/i18n/submit', {
          baseRepo: baseRepo,
          repo: fork.owner.login + '/' + fork.name,
          baseBranch: 'gh-pages',
          path: 'scripts/translations',
          prefix: "angular.module('ngs.i18nManage.demo')\n.config(function($translateProvider) {\n  $translateProvider.translations('{{locale}}',",
          suffix: ");\n});",
          useIndex: false,
          indent: 2,
          extension: 'js'
        })
      },
      request: function(method, path, data) {
        return $http({
          method: method,
          url: apiBaseURL + path,
          data: data,
          withCredentials: true
        })
      }
    }
  })
  .run(function(i18nManager) {
    i18nManager.load()
  });

}();
