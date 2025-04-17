#!/bin/bash
set -ueox pipefail

# compile spice-gtk, spice apis access via C++
sudo dnf install glib-devel cmake valgrind asciidoc libva libva-devel
