Q = require("q")
Path = require("path")
Mime = require("mime")
Async = require("async")
FS = require("fs")

Job = require("./../model/job")
JobStore = require("./../store/job-store")

queue = Async.priorityQueue ((fn, done) -> fn(done)), 10

readdir = (path) -> Q.nfcall(FS.readdir.bind(FS), path)
stat = (file) -> Q.nfcall(FS.stat.bind(FS), file)
split = (path) ->
  readdir(path).then (list) ->
    list = list.map (file) -> Path.resolve(path, file)

    Q.all(list.map(stat)).then (stats) ->
      dirs = []
      files = []
      for file in list
        if stats[list.indexOf(file)].isDirectory()
          dirs.push(file)
        else
          files.push(file) if ["audio/mpeg"].indexOf(Mime.lookup(file)) >= 0

      [files, dirs]

scan = (path, matchFn, priority = 0) ->
  queue.push (next) ->
    job = JobStore.inject(Job.build(message: "Scanning #{path}"))

    split(path).then ([files, dirs]) ->
      JobStore.eject(job)
      next()
      matchFn(path, files)
      dirs.map (dir, index) -> scan(dir, matchFn, index)

  , priority

module.exports =
  scan: scan
