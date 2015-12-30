validate = require("validate.js")

Store = require("./../store")
TrackStore = require("./../store/track-store")

module.exports =
  validations:
    id: {presence: true}
    name: {presence: true}
    artistName: {presence: true}
    basename: {presence: true}
    path: {presence: true}
    albumId: {presence: true}

  build: (props) ->
    defaults =
      artistName: []

    props = Object.merge(defaults, props)
    errors = validate(props, @validations)
    throw new Error("Invalid attributes: #{JSON.stringify(errors)}") if errors?
    props
