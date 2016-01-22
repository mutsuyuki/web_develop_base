#!/bin/bash

echo "---> 'npm init' start"
npm init

echo "---> 'bower init' start"
bower init

echo "---> 'compass init' start"
compass init
rm -rfv sass/
rm -rfv stylesheets/

echo "---> installing node modules start"
npm install --save-dev gulp 'latest'
npm install --save-dev gulp-compass 'latest'
npm install --save-dev gulp-plumber 'latest'
npm install --save-dev gulp-pleeease 'latest'
npm install --save-dev gulp-uglify 'latest'
npm install --save-dev gulp-jade 'latest'
npm install --save-dev gulp-webpack 'latest'
npm install --save-dev bower-webpack-plugin 'latest'
npm install --save-dev main-bower-files  'latest'
npm install --save-dev gulp-typescript 'latest'
npm install --save-dev typescript 'latest'
npm install --save-dev ts-loader 'latest'
npm install --save-dev gulp-tsconfig-update 'latest'
npm install --save-dev gulp-coffee coffee-script 'latest'
npm install --save-dev gulp-imagemin 'latest'
npm install --save-dev gulp-rename 'latest'
npm install --save-dev gulp-filter 'latest'
npm install --save-dev gulp-concat 'latest'
npm install --save-dev mkdirp 'latest'
npm install --save-dev browser-sync 'latest'
npm install --save-dev run-sequence 'latest'
npm install --save-dev gulp-notify 'latest'
npm install --save-dev yargs 'latest'
npm install --save-dev del 'latest'

bower install --save jquery

cd develop/ts/
tsd init
tsd query jquery -rosa install
cd ../../

gulp init_tsconfig
gulp 