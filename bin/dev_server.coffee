#!/usr/bin/env coffee
log = require 'loglevel'
express = require 'express'
webpack = require 'webpack'
WebpackDevServer = require 'webpack-dev-server'

app = express()

webpackDevPort = process.env.PORT or 3004
webpackDevHostname = process.env.WEBPACK_DEV_HOSTNAME

entries = [
  "webpack-dev-server/client?http://#{webpackDevHostname}:#{webpackDevPort}"
  'webpack/hot/dev-server'
  './src/demo'
]

new WebpackDevServer webpack({
  entry: entries
  output:
    path: __dirname,
    filename: 'fam_sdk.js',
    publicPath: "//#{webpackDevHostname}:#{webpackDevPort}/"
  devtool: '#inline-source-map'
  module:
    # postLoaders: [
    #   { test: /\.coffee$/, loader: 'transform/cacheable?envify' }
    # ]
    loaders: [
      { test: /\.coffee$/, loader: 'coffee-loader' }
      { test: /\.json$/, loader: 'json-loader' }
      { test: /\.styl$/, loader: 'style/useable!css!stylus' }
    ]
  plugins: [
    new webpack.HotModuleReplacementPlugin()
  ]
  resolve:
    extensions: ['.coffee', '.js', '.json', '']
}),
  publicPath: "//#{webpackDevHostname}:#{webpackDevPort}/"
  public: "#{webpackDevHostname}:#{webpackDevPort}"
  hot: true
  disableHostCheck: true
.listen webpackDevPort, (err) ->
  if err
    log.trace err
  log.info 'Webpack listening on port %d', webpackDevPort
