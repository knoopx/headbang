import Model from './model'

export default class Track extends Model {
  id: string
  name: string
  artistName: Array<string>
  basename: string
  path: string
  albumId: string
}
