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

/usr/bin/ffmpeg -nostdin -y -i "$input_image" -i "$input_audio" -c:v libx264 -tune stillimage -c:a copy "$output_file"
