#! /bin/bash

CURRENT_DIR=$(cd "$(dirname "$0")";pwd)
cd $CURRENT_DIR/../;
REBAR_TARGET_ARCH=arm-linux-gnueabi; rebar3 as prod tar
