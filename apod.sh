#!/usr/bin/env bash
#File: apod.sh

function getDailyAstroPic {
local imgCredit=$(curl https://api.nasa.gov/planetary/apod?api_key=PFmJjSpr3F8mYvFd0DveMBZfQPlqjqXnpfV6LJMD | jq -r '.copyright')
local date=$(curl https://api.nasa.gov/planetary/apod?api_key=PFmJjSpr3F8mYvFd0DveMBZfQPlqjqXnpfV6LJMD | jq -r '.date')
local title=$(curl https://api.nasa.gov/planetary/apod?api_key=PFmJjSpr3F8mYvFd0DveMBZfQPlqjqXnpfV6LJMD | jq -r '.title')
local link=$(curl https://api.nasa.gov/planetary/apod?api_key=PFmJjSpr3F8mYvFd0DveMBZfQPlqjqXnpfV6LJMD | jq -r '.url')
local imgName=$(basename $link)

wget $link -P /root/

echo "Image Credit: $imgCredit" > /root/file.txt
echo "Date: $date" >> /root/file.txt
echo "Title: $title" >> /root/file.txt
echo "Link: $link" >> /root/file.txt
echo "Image Name: $imgName" >> /root/file.txt

twurl -j -X POST -H upload.twitter.com "/1.1/media/upload.json" -f /root/$imgName -F media > /root/mediaID.txt

local mediaID=$(egrep -o " [0-9]{19}" /root/mediaID.txt)
echo "Media ID: $mediaID" >> /root/file.txt
twurl -X POST -H api.twitter.com "/1.1/statuses/update.json?status=The Astronomy Photo Of The Day (courtesy of NASA) for the day $date is \"$title\". For more details and info check out: https://apod.nasa.gov/apod/astropix.html" | jq
#&media_ids=$mediaID\" | jq

rm /root/$imgName

}
getDailyAstroPic
