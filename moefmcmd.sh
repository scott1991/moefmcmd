#!/bin/bash


while true; do
    #number=$(curl -s -A moefmcmd.sh 'http://www.random.org/integers/?num=1&min=1&max=9&col=1&base=10&format=plain&rnd=new')
    moefm_json=$(curl -s -A moefmcmd.sh 'http://moe.fm/listen/playlist?api=json&api_key=4e229396346768a0c4ee2462d76eb0be052592bf8')
    a=( {0..8} )
    # Fisher-Yates shuffle 算法
    for i in {8..1}
    do
        rand_dev=$(od -An -N2 -i /dev/urandom | tr -d ' ')
        j=$((rand_dev % (i+1)))
        tmp=${a[$j]}
        a[$j]=${a[$i]}
        a[$i]=$tmp
    done
    for i in {0..8}
    do
        mp3_url=$(echo $moefm_json | jq -M -r ".response.playlist[${a[$i]}].url")
        if [ "$mp3_url" == "null" ]; then
            echo "url is null!"
            continue
        fi
        title=$(echo $moefm_json | jq -M -r ".response.playlist[${a[$i]}].sub_title")
        artist=$(echo $moefm_json | jq -M -r ".response.playlist[${a[$i]}].artist")
        album=$(echo $moefm_json | jq -M -r ".response.playlist[${a[$i]}].wiki_title")
        clear
        printf 'Artist: %s\nSong:   %s\nAlbum:   %s\n\n[SPACE] Pause/Continue [q] Next [Ctrl-Z] Exit\n' "$artist" "$title" "$album"
        wget -O "/tmp/mo.mp3" -q "$mp3_url"
	afplay -v 0.2 -q 1 /tmp/mo.mp3
    done
done

