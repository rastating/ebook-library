const path = require('path');
const CopyWebpackPlugin = require('copy-webpack-plugin')

const HtmlWebpackPlugin = require('html-webpack-plugin');
const HtmlWebpackPluginConfig = new HtmlWebpackPlugin();

module.exports = {
  entry: [
    './index.jsx'
  ],
  output: {
    path: path.resolve('../build'),
    filename: 'bundle.js'
  },
  plugins: [
    new CopyWebpackPlugin([
      { from: 'vendor', to: 'vendor' },
      { from: 'assets', to: 'assets' }
    ]),
    new HtmlWebpackPlugin({
      template: './index.html',
      filename: 'index.html',
      inject: 'body',
      hash: true,
      title: 'E-book Library'
    })
  ],
  module: {
    loaders: [
      { test: /\.js$/,  loader: 'babel-loader', exclude: /node_modules/ },
      { test: /\.jsx$/, loader: 'babel-loader', exclude: /node_modules/ },
      { test: /\.css$/, loader: 'style-loader!css-loader', exclude: /node_modules/ }
    ]
  }
}
