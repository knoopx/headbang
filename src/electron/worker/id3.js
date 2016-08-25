import FS from 'fs'
import mm from 'musicmetadata'

export default class ID3 {
  static async fromFile(file: string) {
    return this.fromStream(FS.createReadStream(file))
  }

  static async fromStream(stream) {
    return new Promise((resolve, reject) => {
      const parser = mm(stream, (err, meta) => {
        stream.destroy()
        if (err) { reject(new Error(err)) }
        resolve(meta)
      })
      parser.on('done', () => stream.destroy())
    })
  }
}
