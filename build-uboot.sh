#!/bin/bash

cd ../u-boot-sunxi
export CROSS_COMPILE=arm-linux-gnueabihf-
make distclean
make cubieboard2 
