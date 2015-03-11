gulp       = require 'gulp'
gutil      = require 'gulp-util'
coffeeify  = require 'gulp-coffeeify'
jade       = require 'gulp-jade'
sass       = require 'gulp-sass'
watch      = require 'gulp-watch'
coffeelint = require 'gulp-coffeelint'

require 'coffee-script/register'

BUILD = 'build/'

gulp.task 'jade', ->
  gulp
    .src 'src/**/*.jade'
    .pipe jade pretty: yes
    .pipe gulp.dest BUILD

gulp.task 'coffee', ->
  gulp
    .src 'src/application.coffee'
    .pipe coffeelint()
    .pipe coffeelint.reporter()
    .pipe coffeeify(
      options:
        debug: yes
        paths: ["#{__dirname}/node_modules", "#{__dirname}/src/app"]
    )
    .pipe gulp.dest BUILD

gulp.task 'sass', ->
  gulp
    .src 'src/application.sass'
    .pipe sass()
    .pipe gulp.dest BUILD

gulp.task 'build', ['jade', 'coffee', 'sass']
gulp.task 'default', ['build']
