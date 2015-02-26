gulp       = require 'gulp'
gutil      = require 'gulp-util'
coffee     = require 'gulp-coffee'
mocha      = require 'gulp-mocha'
watch      = require 'gulp-watch'
coffeelint = require 'gulp-coffeelint'
watching   = no

require 'coffee-script/register'

gulp.task 'mocha', ->
  gulp
    .src 'test/**/*.test.coffee', read: no
    .pipe coffeelint()
    .pipe coffeelint.reporter()
    .pipe coffee(bare: yes)
      .pipe(mocha reporter: process.env.MOCHA_REPORTER || 'nyan')

gulp.task 'watch', ->
  gulp.watch '**/*.coffee', ->
    gulp.run 'mocha'

gulp.task 'default', ['mocha']
