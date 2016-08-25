import express from 'express'
import cors from 'cors'
import morgan from 'morgan'
import Path from 'path'
import BodyParser from 'body-parser'
import compression from 'compression'

import AlbumStore from './album-store'
import TrackStore from './track-store'

const router = express()

router.use(morgan('dev'))
router.use(cors())
router.use(BodyParser.json())
router.use(express.static(Path.resolve(__dirname, '../renderer')))

router.patch('/albums/:id', compression(), (request, response) => {
  const album = AlbumStore.get(request.params.id)
  if (album) {
    const result = AlbumStore.inject({...album, ...request.body})
    AlbumStore.dump(result)
    return response.json(result)
  }
  return response.status(404)
})

router.get('/tracks/:id/stream', (request, response) => {
  const track = TrackStore.get(request.params.id)
  if (track) {
    return response.sendFile(track.path)
  }
  return response.status(404)
})

router.get('/albums', compression(), (request, response) =>
  response.json(AlbumStore.filter(request.query))
)

router.get('/tracks', (request, response) => {
  if (request.query.albumId) {
    const album = AlbumStore.get(request.query.albumId)
    if (album) {
      const result = AlbumStore.inject({...album, playCount: album.playCount + 1})
      AlbumStore.dump(result)
    }
  }
  return response.json(TrackStore.filter(request.query))
})

export default router
