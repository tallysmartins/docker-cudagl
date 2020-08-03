#!/bin/sh

# Import utility functions for executing commands and display command messages
. ./utils.sh


# Build the docker image with the name cubu
run docker build -t cudagl .
