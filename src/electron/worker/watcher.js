import FS from 'fs'
import chokidar from 'chokidar'
import Indexer from './indexer'
import Album from './album'

import {shortId} from './support'

export default class Watcher {
  constructor(indexer: Indexer) {
    this.indexer = indexer
  }

  async scanAndIndex(path: string) {
    return this.indexer.index(path)
  }

  removeFromIndex(path: string) {
    Album.eject(shortId(path))
  }

  watch(rootPath: string) {
    chokidar.watch(rootPath)
      .on('ready', () => {
        console.log(`watching ${rootPath} for changes`)
      })
      .on('addDir', (path) => {
        this.scanAndIndex(path).catch(console.log)
      })
      .on('unlinkDir', (path) => {
        this.removeFromIndex(path)
      })
      .on('raw', async (event, path, details) => {
        if (event === 'moved' && details.type === 'directory') {
          if (FS.existsSync(path)) {
            this.scanAndIndex(path, this.agents)
          } else {
            this.removeFromIndex(path)
          }
        }
      })
  }
}
