React = require("react")

module.exports = React.createClass
  displayName: "Divider"
  mixins: [require('react-immutable-render-mixin')]

  getStyle: ->
    if "vertical" of @props
      borderRight: "1px solid #ccc"
      flexBasis: "0"
    else
      borderBottom: "1px solid #ccc"
      flexBasis: "0"

  render: ->
    <div className="divider" style={@getStyle()}/>
