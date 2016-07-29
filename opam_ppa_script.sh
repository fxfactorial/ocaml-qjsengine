#!/bin/sh -ex

sudo apt-add-repository ppa:beineri/opt-qt57-trusty -y
sudo aptitude update -y
sudo aptitude install qt-latest -y
source /opt/qt57/bin/qt57-env.sh
