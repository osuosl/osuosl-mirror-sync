#!/bin/bash

RRD=/data/mirror/rrd
PNG=/data/mirror/www/size

for file in $RRD/*; do
    tree=`basename $file`
    tree=${tree/.rrd/}
    rrdtool graph $PNG/$tree-week.png --imgformat PNG \
        --end now --start end-1w \
        "DEF:raw=$file:size:AVERAGE" "CDEF:size=raw,1048576,*" \
        "AREA:size#507AAA" -l 0 -M >/dev/null
    rrdtool graph $PNG/$tree-month.png --imgformat PNG \
        --end now --start end-1m \
        "DEF:raw=$file:size:AVERAGE" "CDEF:size=raw,1048576,*" \
        "AREA:size#507AAA" -l 0 -M >/dev/null
    rrdtool graph $PNG/$tree-year.png --imgformat PNG \
        --end now --start end-1y \
        "DEF:raw=$file:size:AVERAGE" "CDEF:size=raw,1048576,*" \
        "AREA:size#507AAA" -l 0 -M >/dev/null
done

