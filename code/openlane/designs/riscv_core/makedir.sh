#!/bin/bash

run_tag=$1
dirname=$(dirname "$0")

echo "Creating STA Output folders at: "$dirname

mkdir $dirname/"sta_output_"$run_tag
mkdir $dirname/"sta_output_"$run_tag/synth
mkdir $dirname/"sta_output_"$run_tag/placement
mkdir $dirname/"sta_output_"$run_tag/cts
mkdir $dirname/"sta_output_"$run_tag/route
