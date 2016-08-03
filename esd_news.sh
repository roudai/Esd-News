#!/bin/sh
cd $(dirname $0)
URL="http://comic-earthstar.jp/esd/"
href=$(curl -s ${URL}news.php | grep -m1 -B2 'class="new"' | sed -e '2,3d' | cut -f2 -d"\"")
if [ ! -e latest ] || [ ${href} != $(cat latest) ]; then
  content=$(curl -s ${URL}news.php | grep -m1 -A3 ${href} | sed -e '1,3d' -e 's/<[^>]*>//g' -e 's/^[ ]*//g')
  icon=$(curl -s ${URL}news.php | grep -m1 -A1 ${href} | sed -e '1,1d' \
                                | cut -f4 -d"\"" | cut -f3 -d"/" | sed -e "s/_icon.png//")
  case "${icon}" in
    "anime" ) type="【アニメ出演情報】" ;;
    "cd"    ) type="【CD情報】" ;;
    "event" ) type="【イベント出演情報】" ;;
    "game"  ) type="【ゲーム出演情報】" ;;
    "goods" ) type="【グッズ情報】" ;;
    "live"  ) type="【ライブ出演情報】" ;;
    "media" ) type="【メディア露出情報】" ;;
    "other" ) type="【その他情報】" ;;
    "stage" ) type="【舞台出演情報】" ;;
  esac 
  kotoriotoko/BIN/tweet.sh ${type}${content}" "${URL}${href}
  echo ${href} > latest
fi
