#!/bin/bash
set -xe

# libzip をインストール
dnf install -y libzip libzip-devel
pecl upgrade zip
