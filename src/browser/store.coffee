AbstractStore = require("../common/store")
Axios = require("axios")

class Store extends AbstractStore
  constructor: (@endpoint, identityKey = "id") ->
    super(identityKey)

  fetch: (params) ->
    Axios.get(@endpoint, params: params).then (res) =>
      res.data.forEach (obj) => @inject(obj)
      res.data

module.exports = Store
