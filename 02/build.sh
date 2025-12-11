#!/bin/bash

if [ -f part1.odin ]; then
    odin build part1.odin -file
fi

if [ -f part2.odin ]; then
    odin build part2.odin -file
fi
