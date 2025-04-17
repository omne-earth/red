#!/bin/bash
set -ueox pipefail

# operate libvirt via python
sudo dnf install libvirt libvirt-devel python-devel 

# compile spice-gtk, spice apis access via C++
sudo dnf install glib-devel cmake valgrind asciidoc libva libva-devel

# gemma cpp
sudo dnf install gperftools
