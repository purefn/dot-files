set -eux

# function lndir {
#   oldifs=$IFS
#   IFS='
#   '
#   [ ! -d "$1" ] && { echo "$1 is not a valid directory"; exit 1; }
#   [ ! -d "$2" ] && { mkdir -p "$2"; }
#   src=$(cd "$1" ; pwd)
#   dst=$(cd "$2" ; pwd)
#   find "$src" -type d |
#   while read dir; do
#     mkdir -p "$dst${dir#$src}"
#   done

#   find "$src" -type f -o -type l |
#   while read src_f; do
#     dst_f="$dst${src_f#$src}"
#     ln "$src_f" "$dst_f"
#   done
#   IFS=$oldifs
# }

TR_TORRENT_DIR=${TR_TORRENT_DIR:-$1}
TR_TORRENT_NAME=${TR_TORRENT_NAME:-$2}
TR_TORRENT_ID=${TR_TORRENT_ID:-$3}

# if [ "$TR_TORRENT_DIR" == "/storage/torrents/series/inprogress" ]; then
#   lndir "${TR_TORRENT_DIR}/${TR_TORRENT_NAME}" "/storage/torrents/series/staging/${TR_TORRENT_NAME}"
#   mv "/storage/torrents/series/staging/${TR_TORRENT_NAME}" "/storage/torrents/series/finished/${TR_TORRENT_NAME}"
# elif [ "$TR_TORRENT_DIR" == "/storage/torrents/movies/inprogress" ]; then
#   lndir "${TR_TORRENT_DIR}/${TR_TORRENT_NAME}" "/storage/torrents/movies/staging/${TR_TORRENT_NAME}"
#   mv "/storage/torrents/movies/staging/${TR_TORRENT_NAME}" "/storage/torrents/movies/finished/${TR_TORRENT_NAME}"
# fi

find "$TR_TORRENT_DIR/$TR_TORRENT_NAME" -maxdepth 1 -name "*.rar" -execdir unrar e -o- "{}" \;

