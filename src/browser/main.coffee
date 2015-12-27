require("sugar")

React = require("react")
ReactDOM = require("react-dom")

require("react-tap-event-plugin")()

document.write("<script src=\"http://#{(location.host || 'localhost').split(':')[0]}:35729/livereload.js?snipver=1\"></script>")

ReactDOM.render(React.createElement(require("./components/app")), document.querySelector("#root"))
