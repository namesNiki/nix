pre_query=$(find ~/.steam/steam/steamapps -maxdepth 1 -type f -name '*.acf' -exec awk -F '"' '/"appid|name/{ printf $4 "|" } END { print "" }' {} \; | column -t -s '|' | sort -k 2 | grep -i "")
query="$(echo "$pre_query" | dmenu -fn "JetBrains Mono:size=15" -p "Game:" )"
echo $query

post_query=$(echo "$query" | awk '{print $1}')

cd ~
steam steam://rungameid/$post_query
