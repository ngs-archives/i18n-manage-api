angular.module('ngs.i18nManage.demo')
.config(function($translateProvider) {
  $translateProvider.translations('en',/* begin:generatedData */{
    "title": "I18n Manager Sample",
    "languages": {
      "en": {
        "title": "English"
      },
      "ja": {
        "title": "日本語"
      }
    },
    "introduction": {
      "title": "Demo",
      "paragraph1": "This is a demo application of <b><a href=\"https://github.com/ngs/i18n-manage-api\">i18n manager</a></b>.",
      "paragraph2": "Start inline translating by clicking elements with <kbd>option (alt)</kbd> key."
    },
    "translationTable": {
      "title": "Translations",
      "diffOnlyButton": {
        "title": "Show only diffs"
      },
      "resetButton": {
        "title": "Discard changes"
      }
    },
    "pullRequest": {
      "title": "Pull Request",
      "login": "Login",
      "selectFork": "Select fork",
      "createFork": "Create fork",
      "or": "or",
      "noDiffs": "No diffs"
    }
  }/* end:generatedData */);
});