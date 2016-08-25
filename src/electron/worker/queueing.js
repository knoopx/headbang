import asyncQueue from 'async/queue'
import timetrickle from 'timetrickle'

import Job from './job'
import {shortId} from './support'

export class Queue {
  constructor(max: number, drain: Function = () => {}) {
    this.queue = asyncQueue((fn, callback) => {
      fn().then((result) => {
        callback(null, result)
      }, (err) => {
        callback(err)
      })
    }, max)

    this.queue.drain = drain
  }

  push(fn: Function) {
    return new Promise(async (resolve, reject) => {
      this.queue.push(fn, (err, result) => {
        if (err) {
          reject(err)
        } else {
          resolve(result)
        }
      })
    })
  }
}

export class RateLimit {
  constructor(max: number, timeSpan: number) {
    this.rateLimit = timetrickle(max, timeSpan)
  }

  push(fn: Function) {
    return new Promise((resolve, reject) => this.rateLimit(async () => {
      try {
        resolve(await fn())
      } catch(err) {
        reject(err)
      }
    }))
  }
}

export function queue(_queue: Queue | RateLimit) {
  return (target, key, descriptor) => {
    const fn = descriptor.value
    descriptor.value = function (...args) {
      return _queue.push(() => fn.apply(this, args))
    }
  }
}

export function job(desc: Function) {
  return (target, key, descriptor) => {
    const fn = descriptor.value
    descriptor.value = async function (...args) {
      const description = desc(...args)

      const job = Job.inject(new Job({
        id: shortId(Date.now().toString()),
        type: target.constructor.name,
        desc: description,
        date: Date.now()
      }))

      try {
        console.log(description)
        return await fn.apply(this, args)
      } catch(err) {
        throw err
      } finally {
        Job.eject(job)
      }
    }
  }
}
