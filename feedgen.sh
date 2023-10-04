#!/bin/bash
# Title: spm
# Description: Downloads and installs AppImages and precompiled tar archives.  Can also upgrade and remove installed packages.
# Dependencies: GNU coreutils, tar, wget, python3.x
# Author: simonizor, drsheppard
# License: GPL v2.0 only
# Generates spm-feed.json containing info for AppImages and precompiled tar packages

rm -f "$HOME"/spm/spm-feed.json
cat >"$HOME"/spm/spm-feed.json << EOL
{
  "version": 1,
  "home_page_url": "https://github.com/Drsheppard01/spm",
  "feed_url": "https://simoniz0r.github.io/spm-feed.json",
  "description": "json feed containing package information for spm.",
  "updated_at": "$(date)",
  "expired": false,
  "appimages": [
EOL
for image in $(dir -C -w 1 $HOME/spm/appimages); do
    image="$(echo $image | rev | cut -f2- -d'.' | rev)"
    INSTALLNAME="$(jq -r '.installname' ~/spm/appimages/$image.json)"
    [ "$INSTALLNAME" = "null" ] && INSTALLNAME="$(jq -r '.name' ~/spm/appimages/$image.json | tr '[:upper:]' '[:lower:]')"
    PACKAGETYPE="$(jq -r '.type' ~/spm/appimages/$image.json)"
    [ "$PACKAGETYPE" = "null" ] && PACKAGETYPE="AppImage"
    cat >>"$HOME"/spm/spm-feed.json << EOL
    {
      "name": "$(jq -r '.name' ~/spm/appimages/$image.json)",
      "installname": "$INSTALLNAME",
      "type": "$PACKAGETYPE",
      "description": "$(jq -r '.description' ~/spm/appimages/$image.json)",
      "authors": [
        {
          "name": "$(jq -r '.authors[0].name' ~/spm/appimages/$image.json)",
          "url": "$(jq -r '.authors[0].url' ~/spm/appimages/$image.json)"
        }
      ],
      "links": [
        {
          "type": "$(jq -r '.links[0].type' ~/spm/appimages/$image.json)",
          "url": "$(jq -r '.links[0].url' ~/spm/appimages/$image.json)"
        },
        {
          "type": "$(jq -r '.links[1].type' ~/spm/appimages/$image.json)",
          "url": "$(jq -r '.links[1].url' ~/spm/appimages/$image.json)"
        }
      ],
      "installinfo": [
        {
          "version": "Not Installed",
          "size": "Not Installed",
          "tag": "Not Installed",
          "status": "Not Installed"
        }
      ]
    },
EOL
    echo "$(tput setaf 2)$image has been added to spm-feed.json$(tput sgr0)"
done

cat >>"$HOME"/spm/spm-feed.json << EOL
    {
      "END": "END",
      "name": "END",
      "installname": "removeme",
      "type": "END",
        "authors": [
        {
          "name": "END",
          "url": "END"
        }
      ],
      "links": [
        {
          "type": "END",
          "url": "END"
        },
        {
          "type": "END",
          "url": "END"
        }
      ],
      "installinfo": [
        {
          "version": "END",
          "size": "END",
          "tag": "END",
          "status": "END"
        }
      ]
    }
  ]
}
EOL