#!/bin/bash

echo Hello World
Age=$1
if [ "$Age" -ge 18 ]; then
    echo "You can vote"
else
    echo "You cannot vote"    
fi