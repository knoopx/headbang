require("sugar")
watchify = require('watchify')
browserify = require('browserify')
gulp = require('gulp')
notify = require('gulp-notify')
sourcemaps = require('gulp-sourcemaps')
uglify = require('gulp-uglify')
less = require("gulp-less")
gutil = require('gulp-util')
liveServer = require('gulp-live-server')
autoprefixer = require('gulp-autoprefixer')
buffer = require('vinyl-buffer')
source = require('vinyl-source-stream')

server = liveServer.new('live-server.js')

mainBundle = browserify Object.merge watchify.args,
  entries: 'src/client/main.coffee'
  extensions: ['.coffee', '.cjsx']
  transform: [require('coffee-reactify'), require("babelify")]
  plugin: [require("livereactload")]
  debug: true
.on 'error', gutil.log

bundle = ->
  mainBundle.bundle()
  .on 'error', gutil.log
  .on 'error', notify.onError("Error: <%= error.message %>")
  .pipe source('main.js')
  .pipe buffer()
  .pipe sourcemaps.init(loadMaps: true)
  .pipe sourcemaps.write('.')
  .pipe gulp.dest('build/assets')

gulp.task 'js', bundle

gulp.task 'less', ->
  gulp.src('src/client/main.less')
  .pipe sourcemaps.init()
  .pipe less paths: 'node_modules'
  .on 'error', gutil.log
  .on 'error', notify.onError("Error: <%= error.message %>")
  .pipe autoprefixer()
  .pipe sourcemaps.write('.')
  .pipe gulp.dest('build/assets')

gulp.task 'fonts', ->
  gulp.src(['node_modules/font-awesome/fonts/fontawesome-webfont.*'])
  .pipe gulp.dest('build/assets')

gulp.task 'build', ['fonts', 'js', 'less']

gulp.task 'watch', ->
  watchify mainBundle
  .on 'log', gutil.log
  .on 'update', bundle

  gulp.watch 'build/**/*.css', (changes) -> server.notify(changes)
  gulp.watch 'src/client/**/*', ['less']
  gulp.watch 'src/server/**/*', -> server.start()

gulp.task 'server', ->
  server.start()

gulp.task 'default', ['build', 'server', 'watch']
