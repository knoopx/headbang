require("./build/cli/main").parse([
  '/usr/bin/env node',
  'bin/headbang',
  '--last-fm', process.env["LASTFM_API_KEY"],
  '--force',
  process.env["HEADBANG_LIBRARY"]
]);
