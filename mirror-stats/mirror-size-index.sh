#!/bin/bash

DIR=/data/mirror/www/size

echo "<html>"
echo "<head>"
echo "<title>Mirror Sizes</title>"
echo "</head>"
echo "<body>"
echo "<h2>Mirror Sizes</h2>"

for file in $DIR/*-week.png; do
    base=`basename $file`
    tree=${base/.png/}
    tree=${tree/-week/}
    echo "<div>${tree}<br />"
    echo "<img src=\"$tree-week.png\" />"
    echo "<img src=\"$tree-month.png\" />"
    echo "<img src=\"$tree-year.png\" />"
    echo "</div>"
done

echo "<div>Generated `date`</div>"
echo "</body>"
echo "</html>"

