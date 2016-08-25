import {ipcRenderer} from 'electron'
import React from 'react'
import {render} from 'react-dom'
import reactTapEventPlugin from 'react-tap-event-plugin'

import app from './app'
import './main.global.scss'

reactTapEventPlugin()

render(React.createElement(app), document.querySelector('#root'))

ipcRenderer.send("index")
