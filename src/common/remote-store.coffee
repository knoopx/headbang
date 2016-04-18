Axios = require("axios")

Store = require("./store")

class RemoteStore extends Store
  constructor: (@endpoint, identityKey = "id") ->
    super(identityKey)

  fetch: (params) ->
    Axios.get(@endpoint, params: params).then (res) =>
      res.data.forEach (obj) => @inject(obj)
      res.data

module.exports = RemoteStore
