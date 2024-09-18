#!/bin/bash

# Define the folder to monitor
path="$1"

# Check if ffmpeg is installed
if ! command -v ffmpeg &>/dev/null; then
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
    ffmpeg -i "$webm_file" -filter:v "scale=trunc(iw/2)*2:trunc(ih/2)*2,fps=30" "$mp4_file" &>/dev/null

    if [ $? -eq 0 ]; then
        echo -e "Conversion Successful\nConverted '$webm_file' to '$mp4_file'"
        notify-send "Conversion Successful" "Converted '$webm_file' to '$mp4_file'"
    else
        echo -e "Conversion Failed\nError converting '$webm_file'"
        notify-send "Conversion Failed" "Error converting '$webm_file'"
    fi
}

file_is_webm() {
    file -b --mime-type "$1" | grep -q "video/webm"
}

if [ -f "$path" ]; then

    if ! file_is_webm "$path"; then
        echo "The file is not a valid webm file."
        exit 1
    fi
    convert_webm_to_mp4 "$path"
    exit 1
fi

# Check if folder is provided as an argument
if [[ -z "$path" || ! -d "$path" ]]; then
    echo "Please specify a folder to monitor as an argument."
    exit 1
fi

notify-send "Startup successful" "Folder existence and command existence verified. Starting watch for webm files now"
# Use inotifywait to monitor for changes
while true; do
    inotifywait -r -e close_write "$path" | while read -r dir events filename; do
        # Check if the new file is a webm
        FILEPATH="$dir$filename"
        echo -e "New file detected\n${filename} detected in ${dir}"
        notify-send "New file detected" "${filename} detected in ${dir}"
        if file_is_webm $FILEPATH; then
            echo -e "WEBM file found\n${filename} is a WEBM file. Attempting conversion"
            notify-send "WEBM file found" "${filename} is a WEBM file. Attempting conversion"
            convert_webm_to_mp4 "$FILEPATH"
        else
            echo -e "Not a WEBM file\n${filename} is not a WEBM file. Skipping conversion"
            notify-send "Not a WEBM file" "${filename} is not a WEBM file. Skipping conversion"
        fi

    done
done
