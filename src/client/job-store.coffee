events = require("./events")
JobStore = require("./store")("/jobs")
events.pipe("job", JobStore)

module.exports = JobStore
