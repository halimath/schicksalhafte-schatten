"use strict";

const gulp = require("gulp");
const Vinyl = require("vinyl");
const sass = require("gulp-sass")(require("node-sass"));
const { basename } = require("path");
const puppeteer = require("puppeteer");
const through = require('through2');
const version = process.env.VERSION || require("./package.json").version;

const footer = `
<span style="font-family: sans-serif; font-size: 6px; width: 100%; text-align: center; color: #555555">
    <a href="https://github.com/halimath/schwert-und-schicksal" style="text-decoration: none; color: #555555">github.com/halimath/schwert-und-schicksal</a>
    Version ${version}. This work is licensed under a Creative Commons Attribution 4.0 License.
</span>`

sass.compiler = require("node-sass");

function sassTask() {
    return gulp.src("./styles/*.sass")
        .pipe(sass().on("error", sass.logError))
        .pipe(gulp.dest("./css"));
}

gulp.task("sass", sassTask);

gulp.task("sass:watch", function () {
    gulp.watch(["./styles/**/*.sass"], sassTask);
});

function createPdf(file, enc, cb) {
    let browser
    let page
    let pdfData

    puppeteer.launch()
        .then(b => {
            browser = b;
            return browser.newPage();
        })
        .then(p => {
            page = p;
            return page.goto(`file:${file.path}`, {
                waitUntil: 'networkidle2',
            })
        })
        .then(() => page.pdf({
            format: "A4",
            printBackground: true,
            displayHeaderFooter: true,            
            footerTemplate: footer,
            margin: {
                top: 0,
                left: 0,                
                bottom: 30,
                right: 0,
            },
        }))
        .then(buf => {
            pdfData = buf
            browser.close()
        })
        .then(() => cb(null, new Vinyl({
            path: `${basename(file.path, ".html")}.pdf`,
            contents: pdfData,
        })))
        .catch(e => cb(e))
}

function pdfTask () {
    return gulp.src("./*.html")
        .pipe(through.obj(createPdf))
        .pipe(gulp.dest("out"));
}

gulp.task("pdf", pdfTask);

gulp.task("pdf:watch", function () {
    gulp.watch(["./*.html"], pdfTask);
});

gulp.task("all", gulp.series("sass", "pdf"));
gulp.task("all:watch", () => {
    gulp.watch(["./*.html", "./styles/**/*.sass"], gulp.series("sass", "pdf"))
});
