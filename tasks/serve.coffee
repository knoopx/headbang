gulp = require('gulp')
gutil = require('gulp-util')
notify = require("gulp-notify")
browserify = require('browserify')
buffer = require('vinyl-buffer')
source = require('vinyl-source-stream')
sourcemaps = require('gulp-sourcemaps')
liveServer = require('gulp-live-server')
server = liveServer.new('live-server.js')

gulp.task 'serve', ['browser:fonts', 'browser:css', 'browser:html', 'cli:common', 'cli:server', 'cli:bin', 'cli:package'], ->
  bundle = browserify
    entries: 'src/browser/main.coffee'
    extensions: ['.coffee', '.cjsx']
    transform: ['coffee-reactify', "babelify"]
    cache: {}
    packageCache: {}
    plugin: ["livereactload", "watchify"]

  rebundle = ->
    bundle.bundle()
    .on 'error', notify.onError()
    .pipe source('main.js')
    .pipe buffer()
    .pipe sourcemaps.init(loadMaps: true)
    .pipe sourcemaps.write('.')
    .pipe gulp.dest('build/cli/browser')

  bundle.on 'update', rebundle

  server.start()
  gulp.watch 'src/browser/**/*.less', ['browser:css']
  gulp.watch 'src/browser/**/*.html', ['browser:html']
  gulp.watch 'src/server/**/*.coffee', ['cli:server']
  gulp.watch 'src/common/**/*.coffee', ['cli:common']
  gulp.watch 'src/cli/**/*.coffee', ['cli:bin']
  gulp.watch 'build/cli/browser/**/*.css', (files) -> server.notify(files)
  gulp.watch ['build/cli/main.js', 'build/cli/{server,common}/**/*.js'], -> server.start()

  rebundle()
