#!/usr/bin/env python

import sys
import os
import re


def move_thumbnail_block_to_end(input_file):

    with open(input_file, 'r') as file:
        lines = file.readlines()

    output_file = input_file
    try:
        os.rename(input_file, input_file + ".bak")
    except FileExistsError:
        os.remove(input_file + ".bak")
        os.rename(input_file, input_file + ".bak")

    for i, line in enumerate(lines):
        if "; THUMBNAIL_BLOCK_START" in line:
            start_index = i
        elif "; THUMBNAIL_BLOCK_END" in line:
            end_index = i
            break

    if start_index is not None and end_index is not None:
        thumbnail_block = lines[start_index:end_index+1]
        del lines[start_index:end_index+1]
        lines += thumbnail_block

        with open(output_file, 'w') as file:
            file.write(''.join(lines))
    else:
        print("Thumbnail block not found in the input file")

# Check if input file is provided as a command-line argument
if len(sys.argv) < 2:
    print("Usage: python move_thumbnail_block.py input_file output_file")
else:
    input_file = sys.argv[1]
    move_thumbnail_block_to_end(input_file)
