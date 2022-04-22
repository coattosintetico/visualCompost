#!/bin/bash

# Little script to render the animation made by the script

echo "running sketch..."
xvfb-run processing-java --sketch=/home/greekboy/Documents/programacion/visualCompost --run
echo "sketch finished"
ffmpeg -framerate 24 -pattern_type glob -i './animation/*.png' \
  -i ./audio/visualCompost_audio.mp3 -c:a copy -shortest \
  -c:v libx264 -pix_fmt yuv420p -y animation.mp4