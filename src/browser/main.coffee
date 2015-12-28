require("sugar")
require("source-map-support/register")

window.LiveReloadOptions = { host:(location.host || 'localhost').split(':')[0] }
require('livereload-js')

React = require("react")
ReactDOM = require("react-dom")

require("react-tap-event-plugin")()

ReactDOM.render(React.createElement(require("./components/app")), document.querySelector("#root"))
