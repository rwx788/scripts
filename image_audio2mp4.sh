#!/bin/bash

for i in "$@"
do
    case $i in
    --image=*)
    input_image=${i#*=}
    ;;
    --audio=*)
    input_audio=${i#*=}
    ;;
    -o=*|--output=*)
    output_file=${i#*=}
    ;;
    -h=*|--help=*)
    echo "Specify --image=<path> --audio=<path> and --output=<path>"
    ;;
    *)
    echo "Unknown option, use --help"
    exit 1
    # unknown option
    ;;
    esac
done

/usr/bin/ffmpeg -y -r 1 -i "$input_image" -i "$input_audio" -tune stillimage -shortest -c:v libx264 -c:a copy "$output_file"
