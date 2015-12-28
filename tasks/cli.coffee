gulp = require('gulp')
notify = require("gulp-notify")
sourcemaps = require('gulp-sourcemaps')
source = require('vinyl-source-stream')
coffee = require('gulp-coffee')

gulp.task 'cli:server', ->
  gulp.src('src/server/**/*.coffee')
  .pipe(sourcemaps.init())
  .pipe(coffee())
  .on('error', notify.onError())
  .pipe(sourcemaps.write())
  .pipe(gulp.dest('./build/cli/server'))

gulp.task 'cli:common', ->
  gulp.src('src/common/**/*.coffee')
  .pipe(sourcemaps.init())
  .pipe(coffee())
  .on('error', notify.onError())
  .pipe(sourcemaps.write())
  .pipe(gulp.dest('./build/cli/common'))

gulp.task 'cli:bin', ->
  gulp.src('src/cli/**/*.coffee')
  .pipe(coffee(bare: true))
  .on('error', notify.onError())
  .pipe(gulp.dest('build/cli'))

gulp.task 'cli:package', ->
  packageJSON = Object.select(require("../package"), [
    "name", "version", "description", "repository", "keywords",
    "author", "license", "bugs", "homepage", "dependencies"
  ])
  Object.merge packageJSON,
    name: "#{packageJSON.name}-cli"
    main: "main.js"
    bin:
      headbang: "bin/headbang.js"

  stream = source("package.json")
  stream.end(JSON.stringify(packageJSON))
  stream.pipe(gulp.dest('build/cli'))

gulp.task 'cli:build', ['browser:build', 'cli:common', 'cli:server', 'cli:bin', 'cli:package']
