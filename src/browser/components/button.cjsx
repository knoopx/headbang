React = require("react")

module.exports = React.createClass
  displayName: "Button"
  mixins: [require('react-immutable-render-mixin')]
  render: ->
    <div className="btn btn-default" {...@props} />
