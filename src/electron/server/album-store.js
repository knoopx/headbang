import FS from 'fs'
import Path from 'path'

import TrackStore from './track-store'
import Store from './store'

class AlbumStore extends Store {
  async dump(obj) {
    if (!obj.id || !obj.path) {
      throw new Error('Unexpected argument')
    }
    const path = Path.join(obj.path, '.headbang')
    const tracks = TrackStore.filter({albumId: obj.id})
    const json = JSON.stringify({...obj, tracks})
    FS.writeFileSync(path, json)
    return obj
  }
}

export default new AlbumStore()
