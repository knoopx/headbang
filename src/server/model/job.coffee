UUID = require("uuid")
MD5 = require("crypto/md5")

JobStore = require("./../store/job-store")

module.exports =
  build: (props) ->
    defaults =
      id: MD5.hex_md5(UUID.v4()).to(10)
      startedAt: Date.now()
    Object.merge(defaults, props)
