# i18n-manage-api

Web API to Manage Angular App I18n file.

[![Circle CI](https://circleci.com/gh/kaizenplatform/i18n-manage-api.svg?style=svg&circle-token=dc5fbee552f315f3a96955536b472d6587d71508)](https://circleci.com/gh/kaizenplatform/i18n-manage-api)

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

## Requirements

- Redis
- node

## Testing

```bash
npm test
```

## Start server

```
npm start
```

## Endpoints

### Login

```
GET /login?redirect_url=https://myangularapp.com/
```

### OAuth Callback

```
GET /oauth/callbacks?code=...&state=...
```

### Get I18n

```
GET /i18n?key=en.directives.sidebar.foo
```

Parameter `key` is optional. If not present, responses all stored variables.

### Update I18n

```
POST /i18n -d '{ "key": "en.directives.sidebar.foo", "value": "..." }'
```

Updates value specified with parameters `key` and `value`.

### Submit I18n

```
POST /i18n/submit -d '{ "repo": "myorg/anguar-app", "baseBramch": "master", "path": "app/translations/" }'
```

Creates a branch and sends pull request.

Author
------

[Atsushi Nagase]

License
-------

[MIT License]

[Atsushi Nagase]: http://ngs.io/
[MIT License]: LICENSE
