#!/usr/bin/bash

for i in 0 1 2; do
  running minheap -a 3 minheap-1.yml out/minheap-out-1-$i.yml
  running minheap -a 3 minheap-10.yml out/minheap-out-10-$i.yml
done
