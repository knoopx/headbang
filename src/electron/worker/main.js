import LastFM from './agents/lastfm'
import Discogs from './agents/discogs'

import Watcher from './watcher'
import Indexer from './indexer'

const agents = [
  new LastFM('84324111ccccaa831f917ca14114bd6e'),
  new Discogs('aXHDzbADXfmhdVaHcLVbVjKUGdmjpGVUIoOchoOj')
]

const indexer = new Indexer(agents)
const watcher = new Watcher(indexer)

type Message = {
  method: string,
  args: Array<any>
}

process.on('message', (message: Message) => {
  const {method, args} = message
  watcher[method](...args)
})

process.send({action: 'ready'})
