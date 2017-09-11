const path = require('path');
const webpack = require('webpack');
const HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = {
  entry: {
    main: ['./src/app.tsx'
    ],
  },
  output: {
    filename: '[name].js',
    path: path.resolve(__dirname, 'dist/app'),
    publicPath: '/'
  },
  resolve: {
    extensions: ['.ts', '.tsx', '.js']
  },
  module: {
    rules: [
      {
        test: /\.tsx?$/,
        loader: ['ts-loader']
      }
    ]
  },
  externals: {
    react: 'React',
    'react-dom': 'ReactDOM'
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: __dirname + '/src/index.html',
      filename: 'index.html',
      inject: 'body'
    }),
    new webpack.NamedModulesPlugin()
   ],
  devServer: {
    historyApiFallback: true,
    host: '0.0.0.0'
  },
  // Enable sourcemaps for debugging webpack's output.
  devtool: 'inline-source-map',
}