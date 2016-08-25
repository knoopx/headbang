import path from 'path'
import {dependencies} from './package'
import precss from 'precss'
import autoprefixer from 'autoprefixer'

export default {
  devtool: 'source-map',
  module: {
    loaders: [
      {
        test: /\.global\.scss$/,
        loader: 'style-loader!css-loader!postcss-loader!sass'
      },
      {
        test: /^((?!\.global).)*\.scss$/,
        loader: 'style-loader!css-loader?modules&importLoaders=1!postcss-loader!sass'
      },
      {
        test: /\.jsx?$/,
        loader: 'babel-loader',
        exclude: /node_modules/
      }, {
        test: /\.json$/,
        loader: 'json-loader'
      },
      {
        test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loader: 'url-loader?limit=10000&minetype=application/font-woff'
      },
      {
        test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loader: 'file-loader'
      }
    ]
  },
  postcss () {
    return [precss, autoprefixer]
  },
  output: {
    path: path.join(__dirname, 'dist'),
    filename: 'bundle.js',
    libraryTarget: 'commonjs2'
  },
  resolve: {
    extensions: ['', '.js', '.jsx', '.json'],
    packageMains: ['webpack', 'browser', 'web', 'browserify', ['jam', 'main'], 'main']
  },
  externals: Object.keys(dependencies)
}
