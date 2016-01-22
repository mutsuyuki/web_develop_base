var path                = require('path');
var webpack             = require("gulp-webpack").webpack;
var BowerWebpackPlugin  = require ("bower-webpack-plugin");

module.exports = {
    // エントリーポイント
    entry: {},
    // 出力先
    dest: './deploy/js',
    // 出力するファイル名
    output: {
        filename: '[name].js'
    },
    // 依存関係
    resolve: {
        root:[path.join(__dirname, 'bower_components')],
        moduleDirectories: ["bower_components"],
        extensions:['', '.webpack.js', 'web.js', '.js', '.ts']
    },
    // bowerで取得したライブラリの読み込み用プラグイン
    plugins: [
        new BowerWebpackPlugin()
    ],
    // TypeScriptを読み込むためのloader
    module: {
        loaders: [
            { test: /\.ts$/, loader: 'ts-loader' }
        ]
    }
}