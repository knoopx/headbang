import Immutable from 'immutable'
import EventEmitter from 'events'
import {filter, isObject} from 'lodash/fp'

class Store extends EventEmitter {
  constructor(identityKey = 'id') {
    super()
    this.setMaxListeners(20)
    this.identityKey = identityKey
    this.identityMap = Immutable.Map()
  }

  filter(opts) {
    return filter(opts)(this.identityMap.toArray())
  }

  sort(opts) {
    return this.identityMap.sort(opts)
  }

  sortBy(opts) {
    return this.identityMap.sortBy(opts)
  }

  forEach(fn) {
    return this.identityMap.forEach(fn)
  }

  map(fn) {
    return this.identityMap.map(fn)
  }

  get(id) {
    return this.identityMap.get(id)
  }

  set(id, newObj) {
    const newMap = this.identityMap.set(id, newObj)
    if (!Immutable.is(this.identityMap, newMap)) {
      this.identityMap = newMap
      this.emit('inject', newObj)
      this.emit('change')
    }
    return newObj
  }

  unset(id) {
    const obj = this.identityMap.get(id)
    const newMap = this.identityMap.delete(id)
    if (!Immutable.is(this.identityMap, newMap)) {
      this.emit('eject', obj)
      this.emit('change')
    }
    return obj
  }

  inject(newObj) {
    if (newObj[this.identityKey]) {
      return this.set(newObj[this.identityKey], newObj)
    }
    throw new Error('missing primary key')
  }

  eject(obj) {
    if (isObject(obj)) {
      if (obj[this.identityKey]) {
        return this.unset(obj[this.identityKey])
      }
      throw new Error('missing primary key')
    }

    return this.unset(obj)
  }

  ejectAll() {
    return this.identityMap.map(this.eject)
  }
}

export default Store
