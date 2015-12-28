React = require("react")

module.exports = React.createClass
  displayName: "Button"
  mixins: [require('react-addons-pure-render-mixin')]
  render: ->
    <div className="btn btn-default" {...@props} />
