#!/bin/bash

for i in "$@"
do
    case $i in
    -i=*|--input=*)
    input_file=${i#*=}
    ;;
    -o=*|--output=*)
    output_file=${i#*=}
    ;;
    -h=*|--help=*)
    echo "Specify --input=<path> and --output=<path>"
    ;;
    *)
    echo "Unknown option, use --help"
    exit 1
    # unknown option
    ;;
    esac
done

common_filter="fps=5,scale=800:-1:"
/usr/bin/ffmpeg -nostdin -y -i "$input_dir/$input_file" -vf "${common_filter}flags=lanczos,palettegen" /tmp/palette.png
/usr/bin/ffmpeg -nostdin -y -i "$input_file" -i /tmp/palette.png -filter_complex "${common_filter}flags=lanczos[x];[x][1:v]paletteuse" "$output_file"
