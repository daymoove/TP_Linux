#!/usr/bin/env bash
directory_exist="/srv/yt/downloads"
log="/var/log/yt"
if [ -d "$directory_exist" ] && [ -d "$log" ]; then
        video_url=$1
        video_name=$(youtube-dl -j "$video_url" | cut -d'"' -f8)
        mkdir "/srv/yt/downloads/$video_name"
        youtube-dl -o "/srv/yt/downloads/$video_name/%(title)s.%(ext)s" "$video_url" > "/dev/null"
        youtube-dl --get-description "$video_url" > "/srv/yt/downloads/$video_name/description"
        echo -n "Video "; echo -n "$video_url"; echo " was downloaded."
        echo -n "File path : "; echo -n "/srv/yt/downloads/$video_name/$video_name.mp4"
        echo "[$(date "+%Y/%m/%d %T")] Video $video_url was downloaded. File path : /srv/yt/downloads/$video_name/$video_name.mp4" >> "/var/log/yt/download.log"
else
        exit
fi