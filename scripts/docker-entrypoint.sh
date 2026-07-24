#!/bin/sh
set -e

if [ -n "$SERVER_ADDR" ]; then
    for file in main.py youtubei.py assets/leanback_ajax.json; do
        if [ -f "$file" ]; then
            sed -i "s/ytv2.nossl.revivemii.xyz/$SERVER_ADDR/g" "$file"
        fi
    done

    jar_file="replace-in-swf-1.0.0.jar"
    jar_url="https://github.com/ReviveMii/ReplaceInSwf/releases/download/v1.0.0/$jar_file"

    if [ ! -f "$jar_file" ]; then
        curl -fsSL "$jar_url" -o "$jar_file"
    fi

    if [ -d assets ]; then
        for swf in assets/*.swf; do
            if [ -f "$swf" ]; then
                java -jar "$jar_file" "$swf" "$swf" "ytv2.nossl.revivemii.xyz" "$SERVER_ADDR" >/dev/null 2>&1
            fi
        done
    fi
fi

exec "$@"
