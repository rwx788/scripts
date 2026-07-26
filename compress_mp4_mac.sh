#!/bin/bash

for i in *.MP4; do /opt/homebrew/bin/ffmpeg -i "$i" -vcodec libx265 -crf 23  -vf scale=1920:1080 format=yuv420p "Compressed_${i%.*}.mp4"; done