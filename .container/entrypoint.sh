#!/bin/bash

outputType=$1
shift

case $outputType in
    pdf)
        asciidoctor-pdf -a pdf-theme=/opt/asciidoctor/styles/pdf.yml -a pdf-fontsdir=/usr/share/fonts $@
    ;;

    html)
        asciidoctor -a stylesheet=/opt/asciidoctor/styles/html.css $@
    ;;

    *)
        echo "Unkown output type: $outputType"
        exit 1
    ;;
esac

