require("coffee-script/register");
require("sugar");
require("./src/bin/main").parse([
  '/usr/bin/env node',
  'bin/headbang',
  '--last-fm', process.env["LASTFM_API_KEY"],
  '--force',
  '/Volumes/Storage/Mp3/'
]);
