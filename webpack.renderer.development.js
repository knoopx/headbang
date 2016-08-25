import webpack from 'webpack'
import merge from 'webpack-merge'
import baseConfig from './webpack.base'

export default merge(baseConfig, {
  debug: true,
  devtool: 'cheap-source-map',

  devServer: {
    hot: true
  },

  entry: [
    'webpack-dev-server/client?http://localhost:8080/',
    'webpack/hot/dev-server',
    'babel-polyfill',
    './src/renderer/main'
  ],

  output: {
    publicPath: 'http://localhost:8080/dist/'
  },

  plugins: [
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NoErrorsPlugin(),
    new webpack.DefinePlugin({
      'process.env.NODE_ENV': JSON.stringify('development')
    })
  ],

  target: 'electron-renderer'
})
