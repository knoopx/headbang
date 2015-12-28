gulp = require('gulp')
notify = require("gulp-notify")
browserify = require('browserify')
buffer = require('vinyl-buffer')
source = require('vinyl-source-stream')
sourcemaps = require('gulp-sourcemaps')
less = require("gulp-less")
autoprefixer = require('gulp-autoprefixer')
cssnano = require('gulp-cssnano')

gulp.task 'browser:html', ->
  gulp.src('src/browser/**/*.html')
  .pipe gulp.dest('build/cli/browser')

gulp.task 'browser:js', ->
  browserify
    entries: 'src/browser/main.coffee'
    extensions: ['.coffee', '.cjsx']
    transform: ['coffee-reactify', "babelify"]
  .bundle()
  .pipe source('main.js')
  .pipe buffer()
  .pipe sourcemaps.init(loadMaps: true)
  .pipe sourcemaps.write('.')
  .pipe gulp.dest('build/cli/browser')

gulp.task 'browser:css', ->
  gulp.src('src/browser/main.less')
  .pipe sourcemaps.init()
  .pipe less paths: 'node_modules'
  .on 'error', notify.onError()
  .pipe autoprefixer()
  .pipe(cssnano())
  .pipe sourcemaps.write('.')
  .pipe gulp.dest('build/cli/browser')

gulp.task 'browser:fonts', ->
  gulp.src('node_modules/font-awesome/fonts/fontawesome-webfont.*')
  .pipe gulp.dest('build/cli/browser/fonts')

gulp.task 'browser:build', ['browser:fonts', 'browser:js', 'browser:css', 'browser:html']
