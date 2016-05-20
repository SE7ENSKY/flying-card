var gulp = require("gulp"),
    coffee = require("gulp-coffee"),
    plumber = require("gulp-plumber"),
    gutil = require("gulp-util"),
    pug = require("gulp-pug"),
    stylus = require("gulp-stylus"),
    nib = require("nib"),
    csscomb = require("gulp-csscomb"),
    stripCssComments = require("gulp-strip-css-comments"),
    webserver = require("gulp-webserver"),
    prettifyHtml = require("gulp-html-prettify"),
    beautifyJs = require("gulp-beautify");

gulp.task("coffee", function() {
    gulp.src("./js/main.coffee")
        .pipe(plumber())
        .pipe(coffee({ bare: true }).on("error", gutil.log))
        .pipe(beautifyJs({ indentSize: 4 }))
        .pipe(gulp.dest("./js/"));
});

gulp.task("pug", function() {
    gulp.src("./pug/index.pug")
        .pipe(plumber())
        .pipe(pug())
        .pipe(prettifyHtml({ indent_char: " ", indent_size: 4 }))
        .pipe(gulp.dest("./"));
});

gulp.task("stylus", function(){
    gulp.src("./stylus/screen.styl")
        .pipe(plumber())
        .pipe(stylus({ use: nib(), compress: false }))
        .pipe(stripCssComments({ preserve: false }))
        .pipe(csscomb())
        .pipe(gulp.dest("./css/"));
});

gulp.task("webserver", function() {
    gulp.src("./")
        .pipe(plumber())
        .pipe(webserver({
        livereload: true,
        directoryListing: {
            enable: true,
            path: "../index.html"
        },
        open: true
    }));
});

gulp.task("watch", function() {
    gulp.watch("./js/main.coffee", ["coffee"]);
    gulp.watch("./pug/index.pug", ["pug"]);
    gulp.watch("./stylus/screen.styl", ["stylus"]);
});

gulp.task("default", ["coffee", "pug", "stylus", "webserver", "watch"]);
