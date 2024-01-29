#!/bin/bash

for i in *.MP4; do /usr/bin/ffmpeg -i "$i" -vcodec libx265 -crf 28  -vf scale=1280:720 "Compressed_${i%.*}.mp4"; done