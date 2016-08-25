import ngram from 'ngram-fingerprint'
import crypto from 'crypto'

import normalize from './normalize'

export function shortId(value: string) {
  return crypto.createHash('md5')
    .update(value)
    .digest('hex')
    .slice(0, 10)
}

export function fingerprint(value: string) {
  return ngram(2, normalize.string(value))
}

export default {shortId, fingerprint}
