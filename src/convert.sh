#!/bin/bash

# Define the folder to monitor
FOLDER="$1"

# Check if folder is provided as an argument
if [ -z "$FOLDER" ]; then
  echo "Please specify a folder to monitor as an argument."
  exit 1
fi

# Check if ffmpeg is installed
if ! command -v ffmpeg &> /dev/null; then
  echo "ffmpeg is not installed. Please install ffmpeg before running the script."
  exit 1
fi

# Function to convert webm to mp4
convert_webm_to_mp4() {
  webm_file="$1"
  mp4_file="${webm_file%.*}.mp4"

  # Check if mp4 already exists (optional)
  # if [ -f "$mp4_file" ]; then
  #   echo "$mp4_file already exists. Skipping conversion."
  #   return
  # fi

  # Convert webm to mp4 using ffmpeg
  ffmpeg -i "$webm_file" -filter:v "scale=trunc(iw/2)*2:trunc(ih/2)*2,fps=30" "$mp4_file" &> /dev/null

  if [ $? -eq 0 ]; then
    notify-send "Conversion Successful" "Converted '$webm_file' to '$mp4_file'"
  else
    notify-send "Conversion Failed" "Error converting '$webm_file'"
  fi
}
notify-send "Startup successful" "Folder existence and command existence verified. Starting watch for webm files now"
# Use inotifywait to monitor for changes
while true; do
  inotifywait -e close_write  "$FOLDER" | while read -r dir events filename; do
    # Check if the new file is a webm
    notify-send "New file detected" "${filename} detected in ${FOLDER}"
    if [ "${filename##*.}" == "webm" ]; then
      notify-send "WEBM file found" "${filename} is a WEBM file. Attempting conversion"
      full_filepath="$FOLDER/$filename"
      convert_webm_to_mp4 "$full_filepath"
    fi
  done
done
