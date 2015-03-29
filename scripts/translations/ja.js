angular.module('ngs.i18nManage.demo')
.config(function($translateProvider) {
  $translateProvider.translations('ja',/* begin:generatedData */{
  "title": "I18n 管理デモ",
  "languages": {
    "en": {
      "title": "English"
    },
    "ja": {
      "title": "日本語"
    }
  },
  "introduction": {
    "title": "デモ",
    "paragraph1": "これは <a href=\"https://github.com/ngs/i18n-manage-api\">i18n manager</a> のデモアプリケーションです。",
    "paragraph2": "(WIP) <kbd>ctrl + shift</kbd> キーを押しながら要素をクリックすることで、インライン翻訳が開始できます。"
  },
  "translationTable": {
    "title": "翻訳一覧",
    "diffOnlyButton": {
      "title": "差分のみ表示する"
    },
    "resetButton": {
      "title": "変更を破棄する"
    }
  },
  "pullRequest": {
    "title": "プルリクエスト",
    "login": "ログイン",
    "selectFork": "フォークを選択",
    "createFork": "フォークする",
    "or": "または",
    "noDiffs": "差分がありません"
  }
}/* end:generatedData */);
});
