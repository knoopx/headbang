import webpack from 'webpack'
import ExtractTextPlugin from 'extract-text-webpack-plugin'
import merge from 'webpack-merge'
import baseConfig from './webpack.base'

export default merge(baseConfig, {
  entry: [
    'babel-polyfill',
    './src/renderer/main'
  ],

  output: {
    publicPath: '../dist/',
    filename: 'renderer.js'
  },

  plugins: [
    new webpack.optimize.OccurrenceOrderPlugin(),
    new webpack.DefinePlugin({
      'process.env.NODE_ENV': JSON.stringify('production')
    }),
    new webpack.optimize.UglifyJsPlugin({
      compressor: {
        screw_ie8: true,
        warnings: false
      }
    }),
    new ExtractTextPlugin('style.css', {allChunks: true})
  ],

  target: 'electron-renderer'
})
