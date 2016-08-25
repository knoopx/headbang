import {Queue} from './queueing'

export default {
  index: new Queue(16),
  lookup: new Queue(16)
}
