require("sugar")

React = require("react")
ReactDOM = require("react-dom")

require("react-tap-event-plugin")()

App = React.createElement(require("./components/app"))

app = ReactDOM.render(App, document.querySelector("#root"))
