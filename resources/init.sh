#!/bin/sh

if [ -d /data/yacy ]; then
  echo 'Found existing directory at /data/yacy.  Skipping initialization.'
  exit 0
fi

mkdir -p /data/yacy
echo "Created /data/yacy directory."

echo 'Finished!'
