# Character Record Sheet for D&D 3.0

This repo contains a HTML based character record sheet for D&D 3.0. The record
sheet is available in German language.

The sheet is created using HTML and custom CSS (making massive use of flexbox).

To create a PDF version, a [puppeteer](https://github.com/puppeteer/puppeteer/)
script is provided.

## Downloads

You may download generated PDF version from the [releases page](https://github.com/halimath/dnd30crs/releases/).

## How to develop

You need [nodejs](https://nodejs.org/en/) and npm installed.

1. Install dependencies

```
$ npm i
```

2. Generate CSS

```
$ npm run build
```

or alternatively

```
$ npm start
```

which will run sass compiler in watch mode.

3. Generate PDF

```
$ npm run create-pdf
```

# License

This work is licensed under a Creative Commons Attribution 4.0 License.