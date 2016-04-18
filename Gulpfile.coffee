require("sugar")
require("source-map-support/register")
require("./tasks/browser")
require("./tasks/cli")
require("./tasks/serve")

gulp = require("gulp")

process.env.NODE_ENV = 'production';

gulp.task 'default', ['serve']
