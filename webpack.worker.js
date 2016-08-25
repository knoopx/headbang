import webpack from 'webpack'
import merge from 'webpack-merge'
import baseConfig from './webpack.base'

export default merge(baseConfig, {
  entry: [
    'source-map-support/register',
    'babel-register',
    'babel-polyfill',
    './src/electron/worker/main'
  ],

  output: {
    filename: 'worker.js'
  },

  plugins: [
    new webpack.DefinePlugin({
      'process.env': {
        NODE_ENV: JSON.stringify(process.env.NODE_ENV)
      }
    })
  ],

  target: 'electron-main',
  node: {
    __dirname: false,
    __filename: false
  }
})
