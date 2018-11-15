#!/usr/bin/env bash
# used for the amazon instance name setup by FC
set -e -x
# enabled debug
apt-get update -y
# Locales
locale-gen en_GB.UTF-8