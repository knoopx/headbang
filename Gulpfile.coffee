require("sugar")
require("./tasks/browser")
require("./tasks/cli")
require("./tasks/serve")

gulp = require("gulp")

gulp.task 'default', ['serve']
