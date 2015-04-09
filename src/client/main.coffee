require("sugar")

React = require("react")
ReactDOM = require("react-dom")

require("react-tap-event-plugin")()

ReactDOM.render(React.createElement(require("./components/app")), document.querySelector("#root"))
