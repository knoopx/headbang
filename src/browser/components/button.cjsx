React = require("react")

module.exports = React.createClass
  render: ->
    <div className="btn btn-default" {...@props} />
