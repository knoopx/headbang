import Axios from 'axios'
import socketIO from 'socket.io-client'
import {autobind} from 'core-decorators'
import {observable, computed} from 'mobx'

import Collection from './store/collection'

class Resource {
  constructor(endpoint) {
    this.endpoint = endpoint
  }

  async find(id) {
    const res = await Axios.get(`${this.endpoint}/${id}`)
    return res.data
  }

  async findAll(params) {
    const res = await Axios.get(this.endpoint, {params})
    return res.data
  }

  async update(id, props) {
    const res = await Axios.patch(`${this.endpoint}/${id}`, props)
    return res.data
  }
}

class Albums extends Resource {
  constructor(endpoint) {
    super(`${endpoint}/albums`)
  }
}

class Tracks extends Resource {
  constructor(endpoint) {
    super(`${endpoint}/tracks`)
  }
}

class Jobs extends Resource {
  constructor(endpoint) {
    super(`${endpoint}/jobs`)
  }
}

class Client {
  constructor(endpoint) {
    this.socket = socketIO(endpoint)
    this.albums = new Albums(endpoint)
    this.tracks = new Tracks(endpoint)
    this.jobs = new Jobs(endpoint)
  }
}

@autobind
class Store {
  @observable endpoint = 'http://localhost:3366'

  @computed get client() {
    return new Client(this.endpoint)
  }

  albums = new Collection()
  tracks = new Collection()
  jobs = new Collection()

  constructor() {
    this.client.socket.on('connect', this.fetch)
    this.client.socket.on('inject:album', this.albums.inject)
    this.client.socket.on('eject:album', this.albums.eject)
    this.client.socket.on('inject:job', this.jobs.inject)
    this.client.socket.on('eject:job', this.jobs.eject)
  }

  async fetch() {
    ['albums'].forEach(async (key) => {
      const results = await this.client[key].findAll()
      results.forEach(this[key].inject)
    })
  }
}

export default new Store()
