import webpack from 'webpack'
import merge from 'webpack-merge'

import baseConfig from './webpack.base'

export default merge(baseConfig, {
  entry: [
    'source-map-support/register',
    'babel-register',
    'babel-polyfill',
    './src/electron/main'
  ],

  output: {
    filename: 'main.js'
  },

  plugins: [
    new webpack.optimize.UglifyJsPlugin({
      compressor: {
        warnings: false
      }
    }),

    new webpack.DefinePlugin({
      'process.env': {
        NODE_ENV: JSON.stringify('production')
      }
    })
  ],

  target: 'electron-main',
  node: {
    __dirname: false,
    __filename: false
  }
})
