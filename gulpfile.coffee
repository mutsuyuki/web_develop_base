#パス定義（ルートディレクトリ）
development_dir     = 'develop/'
deployment_dir 	    = 'deploy/'

#パス定義（種別）
jade_dir 	        = 'jade/'
css_dir 	        = 'css/'
sass_dir            = 'sass/'
js_dir              = 'js/'
typescript_dir      = 'ts/'
image_dir           = 'img/'

#TypeScript エントリポイント
ts_entry_points     = 
    index: 'index.ts'
    next : 'next.ts'

#ライブラリ読み込み
gulp 	            = require 'gulp'
compass 	 	    = require 'gulp-compass'
plumber 	 	    = require 'gulp-plumber'
pleeease            = require 'gulp-pleeease'
uglify 		 	    = require 'gulp-uglify'
jade                = require 'gulp-jade'
webpack             = require 'gulp-webpack'
typescript          = require 'gulp-typescript'
tsConfUpdate        = require 'gulp-tsconfig-update'
coffee              = require 'gulp-coffee'
imagemin            = require 'gulp-imagemin'
rename              = require 'gulp-rename'
filter              = require 'gulp-filter'
concat              = require 'gulp-concat'
mainBowerFiles      = require 'main-bower-files'
mkdirp              = require 'mkdirp'
browserSync         = require 'browser-sync'
runSequence         = require 'run-sequence'
notify              = require 'gulp-notify'
yargs               = require 'yargs'
del                 = require 'del'


#   Jadeコンパイル
# -----------------
gulp.task 'jade_compile', ->

    src = development_dir + '**/*.jade'

    gulp.src src
    .pipe plumber({errorHandler: notify.onError('<%= error.message %>')})
    .pipe jade ( 
        pretty : true
    )
    .pipe gulp.dest deployment_dir


#   Compass(Sass)コンパイル
# --------------------------
gulp.task 'compass_compile', ->

    src = development_dir + '**/*.scss'

    gulp.src src
    .pipe plumber({errorHandler: notify.onError('<%= error.message %>')})
    .pipe compass(
        comments:    false
        css: 	     deployment_dir  + css_dir
        sass:        development_dir + sass_dir
    )
    .pipe pleeease(
        autoprefixer: ['last 4 versions']
        minifier    : true
    )


#   Typescripeコンパイル
# ----------------------
gulp.task 'typescript_compile', ->

    tsConfig       = require ('./tsconfig.json' )

    webpackConfig  = require ('./webpack.config.js');
    for key, file_name of ts_entry_points
        webpackConfig.entry[key] = './' + development_dir + typescript_dir + file_name
    
    src = [
                development_dir + typescript_dir + '**/*.ts'
        '!./' + development_dir + typescript_dir + 'ts/typings'
    ]
    
    gulp.src src
    .pipe plumber({errorHandler: notify.onError('<%= error.message %>')})
    .pipe tsConfUpdate()
    .pipe typescript tsConfig.compilerOptions
    .pipe webpack webpackConfig
    .pipe gulp.dest(deployment_dir + js_dir)


#   Bowerマージ
# ----------------
gulp.task 'bower_merge',  ->

    jsFilter = filter '**/*.js'

    gulp.src mainBowerFiles()
    .pipe jsFilter
    .pipe concat 'lib.js'
    .pipe gulp.dest( deployment_dir + js_dir )


#   Image最適化
# ---------------
gulp.task 'image_min', ->

    src = development_dir + image_dir + '**/*.+(jpg|jpeg|png|gif|svg)'
    
    gulp.src src
    .pipe plumber({errorHandler: notify.onError('<%= error.message %>')})
    .pipe imagemin()
    .pipe gulp.dest(deployment_dir + image_dir)
    

#   ブラウザリロード
# ------------------
gulp.task 'browserSync_reload', ->

    browserSync.reload()


#   クリーン
# ------------
gulp.task 'clean_html', (callback) ->

    del(
        [deployment_dir + '*.html'],
        {force:true},
        callback
    );


gulp.task 'clean_css', (callback) ->

    del(
        [deployment_dir + css_dir + '**/*.css'],
        {force:true},
        callback
    );


gulp.task 'clean_js', (callback) ->

    del(
        [deployment_dir + js_dir + '**/*.js'],
        {force:true},
        callback
    );


gulp.task 'clean_img', (callback) ->

    del(
        [deployment_dir + image_dir + '**/*.+(jpg|jpeg|png|gif|svg)'],
        {force:true},
        callback
    );


#   ビルド
# ------------
gulp.task 'build_html', (callback) ->

    runSequence(
        'clean_html',
        ['jade_compile'],
        'browserSync_reload',
        callback
    )


gulp.task 'build_css', (callback) ->

    runSequence(
        'clean_css',
        'compass_compile',
        'browserSync_reload',
        callback
    )


gulp.task 'build_js', (callback) ->

    runSequence(
        'clean_js',
        ['bower_merge', 'typescript_compile'],
        'browserSync_reload',
        callback
    )


gulp.task 'build_img', (callback) ->

    runSequence(
        'clean_img',
        'image_min',
        'browserSync_reload',
        callback
    )



#   更新監視
# ------------
gulp.task 'watch', ->

    gulp.watch development_dir + '**/*.jade'                    , ['build_html']
    gulp.watch development_dir + '**/*.scss'                    , ['build_css']
    gulp.watch development_dir + '**/*.ts'                      , ['build_js']
    gulp.watch development_dir + '**/*.+(jpg|jpeg|png|gif|svg)' , ['build_img']

    browserSync.init(null, { server: baseDir: './deploy/' })


#   メイン
# ----------
gulp.task 'default', (callback) ->

    runSequence( 
        ['build_html', 'build_css', 'build_js', 'build_img'],
        'watch',
         callback 
    )


#   tsconfig.json 初期化
# -----------------------
gulp.task 'init_tsconfig', ->

    src = development_dir + typescript_dir + '**/*.ts'

    gulp.src src
    .pipe tsConfUpdate()
