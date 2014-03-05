import sys, os
import rrdtool, tempfile
path="/data/mirror/rrd"
dirList=os.listdir(path)
os.chdir(path)
count = 0
alternating = 0
table_data = ""
table_array = []
for fname in dirList:
    try:
        info = rrdtool.info(fname)
        size = int(info['ds[size].last_ds']) / 1024
        name = '%s - %i GB' % (info['filename'][:-4].title(), size)
        table_array.append((size, name))
    except:
        print "Filename %s is empty?" % fname

table_array.sort(key=lambda row: row[0], reverse=True)

for size, name in table_array:
    table_data+="data.setValue(%i,%i,'%s');\n" % (count,alternating,name)
    alternating = 1
    table_data+="data.setValue(%i,%i,%i);\n" % (count,alternating,size)
    alternating = 0
    count+=1


html = """
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <title>
      Wall O' Shame
    </title>
    <script type="text/javascript" src="http://www.google.com/jsapi"></script>
    <script type="text/javascript">
      google.load('visualization', '1', {packages: ['corechart']});
    </script>
    <script type="text/javascript">
      function drawVisualization() {
        // Create and populate the data table.
        var data = new google.visualization.DataTable();
        data.addColumn('string', 'Project');
        data.addColumn('number', 'Disk space');
        data.addRows(%i);
        %s
        // Create and draw the visualization.
        var chart = new google.visualization.PieChart(document.getElementById('visualization'))
        chart.draw(data, {title:"Wall O' Shame", sliceVisibilityThreshold:0.01});
      }
      

      google.setOnLoadCallback(drawVisualization);
    </script>
  </head>
  <body style="font-family: Arial;border: 0 none;">
    <div id="visualization" style="width: 800px; height: 600px;"></div>
  </body>
</html>""" % (count,table_data)

print html
