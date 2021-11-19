#!/usr/bin/env bash
directory_exist="/srv/yt/downloads"
log="/var/log/yt"
while true; do
        if [ -d "$directory_exist" ] && [ -d "$log" ]; then
                cat /srv/yt/yt_dl | while read -r line; do
                        video_url=$line
                        video_name=$(youtube-dl -j "$video_url" | cut -d'"' -f8)
                        mkdir "/srv/yt/downloads/$video_name"
                        youtube-dl -o "/srv/yt/downloads/$video_name/%(title)s.%(ext)s" "$video_url" > "/dev/null"
                        youtube-dl --get-description "$video_url" > "/srv/yt/downloads/$video_name/description"
                        echo -n "Video "; echo -n "$video_url"; echo " was downloaded."
                        echo -n "File path : "; echo -n "/srv/yt/downloads/$video_name/$video_name.mp4"
                        echo "[$(date "+%Y/%m/%d %T")] Video $video_url was downloaded. File path : /srv/yt/downloads/$video_name/$video_name.mp4" >> "/var/log/yt/download.log"
                        sed -i '1d' "/srv/yt/yt_dl"
                done
        else
                exit
        fi
        sleep 30
done