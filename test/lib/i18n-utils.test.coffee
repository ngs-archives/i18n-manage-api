i18nUtils = require '../../lib/i18n-utils'
expect = require 'expect.js'
fs = require 'fs'
{loadFixture} = require '../helper'

describe 'i18nUtils', ->
  coffeeFile = subject = obj = _obj = _tree = prefix = tree = null
  beforeEach ->
    _obj = _tree = null
    prefix = -> 'lib/bundle/translations/'
    tree = -> _tree ||= loadFixture 'tree'
    obj = -> _obj ||= loadFixture 'i18n'
    coffeeFile = -> fs.readFileSync "#{__dirname}/../fixtures/i18n-exports.coffee"

  describe '::find', ->
    pathComponents = null
    beforeEach ->
      pathComponents = -> ['en', 'directives', 'sidebar']
      subject = -> i18nUtils.find obj(), pathComponents()

    it 'returns object', ->
      expect(subject()).to.eql { foo: 'Test' }

    it 'returns value', ->
      pathComponents = -> ['en', 'directives', 'sidebar', 'foo']
      expect(subject()).to.be 'Test'

    it 'returns empty object when inexistent', ->
      pathComponents = -> ['foo', 'bar', 'piyo']
      expect(subject()).to.eql {}

  describe '::toResources', ->
    beforeEach ->
      subject = -> i18nUtils.toResources obj(), prefix()

    it 'returns pair of paths and resources', ->
      expect(subject()).to.eql
        'lib/bundle/translations/en/directives/index.coffee':
          sidebar:
            foo: "Test"
        'lib/bundle/translations/en/filters/index.coffee':
          too_old:
            ago: "Ago"
        'lib/bundle/translations/ja/directives/index.coffee':
          sidebar:
            foo: "テスト"
        'lib/bundle/translations/ja/filters/index.coffee':
          too_old:
            ago: "顎"

  describe '::getPendingResources', ->
    beforeEach ->
      subject = -> i18nUtils.getPendingResources tree(), obj(), prefix()
    it 'returns resources to create and update', ->
      expect(subject()).to.eql
        create: [
          {
            data:
              sidebar:
                foo: "テスト"
            path: "lib/bundle/translations/ja/directives/index.coffee"
          }
        ]
        update: [
          {
            data:
              too_old:
                ago: "顎"
            path: "lib/bundle/translations/ja/filters/index.coffee"
            sha: "0000000000000000000000000000000000000003"
          }
          {
            data:
              sidebar:
                foo: "Test"
            path: "lib/bundle/translations/en/directives/index.coffee"
            sha: "0000000000000000000000000000000000000001"
          }
          {
            data:
              too_old:
                ago: "Ago"
            path: "lib/bundle/translations/en/filters/index.coffee"
            sha: "0000000000000000000000000000000000000002"
          }
        ]
        keep: [
          {
            path: "lib/bundle/translations/ja/errors/index.coffee"
            sha: "0000000000000000000000000000000000000004"
          }
        ]

  describe '::createFile', ->
    beforeEach ->
      subject = -> i18nUtils.createFile obj()
    it 'creates coffee file', ->
      expect(subject()).to.eql """
      'use strict'

      module.exports =
        ja:
          directives:
            sidebar:
              foo: "テスト"
          filters:
            too_old:
              ago: "顎"
        en:
          directives:
            sidebar:
              foo: "Test"
          filters:
            too_old:
              ago: "Ago"
      """

    describe '::parseFile', ->
      content = null
      beforeEach ->
        content = -> coffeeFile()
        subject = -> i18nUtils.parseFile content()
      it 'parses coffee file', ->
        expect(subject()).to.eql obj()

    describe '::updateFile', ->
      content = null
      beforeEach ->
        content = -> coffeeFile()
        subject = -> i18nUtils.updateFile content(), ja: directives: sidebar: baz: 'qux'
      it 'updates coffee file', ->
        expect(subject()).to.eql """
        'use strict'

        module.exports =
          ja:
            directives:
              sidebar:
                foo: "テスト"
                baz: "qux"
            filters:
              too_old:
                ago: "顎"
          en:
            directives:
              sidebar:
                foo: "Test"
            filters:
              too_old:
                ago: "Ago"
        """

