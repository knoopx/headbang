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

  build: (attrs) ->
    defaults =
      artistName: []

    attrs = Object.merge(defaults, attrs)
    errors = validate(attrs, @validations)
    throw new Error("Invalid attributes: #{JSON.stringify(errors)}") if errors?
    attrs
