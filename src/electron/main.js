import {app, BrowserWindow} from 'electron'
import electronDebug from 'electron-debug'
import {Server as createServer} from 'http'
import {fork} from 'child_process'

import AlbumStore from './server/album-store'
import TrackStore from './server/track-store'
import JobStore from './server/job-store'

import router from './server/router'
import io from './server/io'

electronDebug({showDevTools: true})

let win

function createWindow() {
  win = new BrowserWindow({width: 1920, height: 1080, titleBarStyle: 'hidden'})
  win.loadURL(`file://${__dirname}/index.html`)
}

app.on('ready', createWindow)

app.on('activate', () => {
  if (win === null) {
    createWindow()
  }
})

const server = createServer(router)
io(server)
server.listen(3366)

const mapping = {
  Album: AlbumStore,
  Track: TrackStore,
  Job: JobStore
}

AlbumStore.on('inject', (album) => {
  AlbumStore.dump(album).catch(console.log)
})

const worker = fork(__dirname + '/worker.js')
worker.on('message', (message) => {
  const {action, type, target} = message

  if (action === 'ready') {
    worker.send({method: 'watch', args: ['/Volumes/Storage/Mp3/Archive']})
  } else {
    mapping[type][action](target)
  }
})
