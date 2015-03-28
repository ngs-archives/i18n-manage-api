angular.module('ngs.i18nManage.demo')
.config(function($translateProvider) {
  $translateProvider.translations('en',/* begin:generatedData */{
    "title": "I18n Manager Demo 2",
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
        "paragraph1": "This is a demo application of <a href=\"https://github.com/ngs/i18n-manage-api\">i18n manager.",
        "paragraph2": "Start inline translating by clicking element with <kbd>ctrl + shift</kbd> key."
    },
    "translationTable": {
        "title": "Translations",
        "diffOnlyButton": {
            "title": "Show only diffs"
        }
    },
    "pullRequest": {
        "title": "Pull Request",
        "login": "Login",
        "selectFork": "Select fork",
        "createFork": "Create fork",
        "or": "or"
    }
}/* end:generatedData */);
});