#!/usr/bin/env bash

DB_USER=$1
DB_PASS=$2
HASH=$3
PLUGIN_ZIP=$4
DEMO_URL=$5
ROOTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ ! $DB_USER ] || [ ! $DB_PASS ] || [ ! $HASH ] || [ ! $PLUGIN_ZIP ] || [ ! $DEMO_URL ]; then
    echo "Usage: $0 <db_user> <db_pass> <hash> <plugin_zip> <demo_url>"
    exit;
fi

if [ -d "$ROOTPATH/site/$HASH" ]; then
    rm -rf "$ROOTPATH/site/$HASH"
fi

mkdir -p "$ROOTPATH/site/$HASH"
cd "$ROOTPATH/site/$HASH"

wp core download
wp core config --dbname="demo_$HASH" --dbuser="$DB_USER" --dbpass="$DB_PASS"
wp db drop --yes
wp db create
wp core install --url="$DEMO_URL" --title="Demo Site" --admin_user="admin" --admin_password="admin" --admin_email="admin@example.com"

wp plugin install "$PLUGIN_ZIP"
PLUGIN_FILE=${PLUGIN_ZIP##*/}
wp plugin activate "${PLUGIN_FILE%.*}"