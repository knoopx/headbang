import {ObservableMap} from 'mobx'
import {filter, isObject} from 'lodash/fp'
import {autobind} from 'core-decorators'
import query from 'qry'

@autobind
export default class Store extends ObservableMap {
  constructor(initial = {}, identityKey = 'id') {
    super(initial)
    this.identityKey = identityKey
  }

  subscribe(fn){
    this.observe(({type, name, newValue}) => {
      switch (type){
        case 'add':
        case 'update':
          fn('inject', name, newValue)
          break
        case 'delete':
          fn('eject', name, newValue)
          break
      }
    })
  }

  get length(){
    return this.size
  }

  filter(opts) {
    return filter(opts)(this.values())
  }

  where(filter) {
    return this.filter(query(filter))
  }

  reduce(fn, initial) {
    return this.values().reduce(fn, initial)
  }

  inject(props) {
    if (props[this.identityKey]) {
      this.upsert(props[this.identityKey], props)
      return props
    }

    throw new Error('missing primary key')
  }

  upsert(id, props) {
    this.set(props[this.identityKey], props)
    return props
  }

  updateAll(where, props) {
    return this.filter(query).map((obj) => this.update(obj.id, props))
  }

  update(id, newProps) {
    const prevProps = this.get(id)
    if (prevProps) {
      const props = {...prevProps, ...newProps}
      this.set(id, props)
      return props
    }
  }

  remove(id){
    const prevProps = this.get(id)
    if (prevProps) {
      this.delete(id)
      return prevProps
    }
  }

  removeAll(query) {
    return this.where(query).map((obj) => this.remove(obj.id))
  }

  eject(obj) {
    if (isObject(obj)) {
      if (obj[this.identityKey]) {
        this.remove(obj[this.identityKey])
        return obj
      }
      throw new Error('missing primary key')
    } else {
      this.remove(obj)
      return obj
    }
  }

  ejectAll() {
    this.values().forEach(this.eject)
  }
}
