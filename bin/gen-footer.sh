#!/bin/bash

HOST=`hostname -f`
BANDWIDTH=`cat /var/www/header-inc/ubar.txt`
YEAR=`/bin/date +%Y`
DEST='/var/www/header-inc/README.html'

if true; then

echo "
<div class=\"footer\">
<table><tr><td><div class=\"info\">Powered by:</div>&nbsp;&nbsp;&nbsp;</td>"
if [ "$HOST" != "ftp-osl.osuosl.org" ]; then
echo "
	<td><a href=\"http://www.tds.net\">
	<img src=\"/header-inc/tds_120.gif\" border=\"0\" align=\"middle\"
	/></a>&nbsp;&nbsp;&nbsp;</td>"
fi
echo "
	<td><a href=\"http://osuosl.org/\">
	<img src=\"/header-inc/osl_logo.png\" border=\"0\" align=\"middle\"
	/></a>&nbsp;&nbsp;&nbsp;</td>

	<td><center>
	<a href=\"http://osuosl.org/contribute\" target=\"_blank\">
	<img src=\"http://$HOST/header-inc/give6_medium.png\" border=\"0\"
	/></a><br /><div class=\"info\">
	Your donation powers our service to the FOSS community.
	</div></center></td></tr></table>
        <br />
	
	<div class=\"bwbar\">
	<img src=\"http://$HOST/header-inc/ubar.png\" /></div>
	<div class=\"info\">$BANDWIDTH | <a href=\"http://osuosl.org/\">OSUOSL</a> &#169; $YEAR</div>
        </div>
</div>
</BODY>
</HTML>
"

fi > $DEST
