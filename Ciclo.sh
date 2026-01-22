#!/bin/bash

DIR=$1
MemVid_DIR=$HOME/IA/vectors
RAMDISK="/dev/shm/"
echo DIR=$DIR

List_prev=$(bash -c ls $DIR)

echo List_prev=$List_prev

