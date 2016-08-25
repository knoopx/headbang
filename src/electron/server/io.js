import socketIO from 'socket.io'
import AlbumStore from './album-store'
import TrackStore from './track-store'
import JobStore from './job-store'

export default function (server) {
  const io = socketIO(server)

  io.on('connection', socket => {
    JobStore.forEach((job) => {socket.emit('inject:job', job)})
    AlbumStore.on('inject', obj => { socket.emit('inject:album', obj) })
    AlbumStore.on('eject', obj => socket.emit('eject:album', obj.id))
    TrackStore.on('inject', obj => socket.emit('inject:track', obj))
    TrackStore.on('eject', obj => socket.emit('eject:track', obj.id))
    JobStore.on('inject', obj => socket.emit('inject:job', obj))
    JobStore.on('eject', obj => socket.emit('eject:job', obj.id))
  })
}
