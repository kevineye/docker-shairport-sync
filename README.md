# Run

    docker run --rm -it --net host --device /dev/snd -e AIRPLAY_NAME=Docker kevineye/shairport-sync

    docker run --rm -it --net host --device /dev/snd -e AIRPLAY_NAME=Docker kevineye/shairport-sync --help

    docker run --rm -it --net host --device /dev/snd -e AIRPLAY_NAME=Docker -v /some/pipe:/output kevineye/shairport-sync -o pipe -- /output

