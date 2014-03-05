#!/bin/bash

# class,Link name,link reference

INFO="
others,Others,http://ftp.osuosl.org/pub/
apache,Apache,http://apache.osuosl.org/
debian,Debian,http://debian.osuosl.org/
gentoo,Gentoo,http://gentoo.osuosl.org/
kernel,Kernel,http://kernel.osuosl.org/pub/
mozilla,Mozilla,http://mozilla.osuosl.org/
slackware,Slackware,http://slackware.osuosl.org/
suse,Suse,http://suse.osuosl.org/
ubuntu,Ubuntu,http://ubuntu.osuosl.org/
"

RELATIVE_STYLE="/header-inc/style.css"

DIR=/data/header-inc/
CSS=style.css
HTML=HEADER.html

# gen info
for i in $INFO
do
	CLASS=`echo $i | cut -d"," -f1`
	LINK=`echo $i | cut -d"," -f2`
	REF=`echo $i | cut -d"," -f3`
	UL="$UL <li class=\"$CLASS\"><a href=\"$REF\">$LINK</a></li>"
	CSSUL1="$CSSUL1, body#$CLASS li.$CLASS"
	CSSUL2="$CSSUL2, body#$CLASS li.$CLASS a"
done

# hack to remove leading comma :(

CSSUL1=`echo $CSSUL1 | sed -e 's/^, //'`
CSSUL2=`echo $CSSUL2 | sed -e 's/^, //'`

# lets print out this stuff!

# css first

echo "

body {
	background-color: #FFF;
	margin: 0 auto 0 auto;			
	width: 47em;
}

hr {
	width: 100%;
}

.main {
	margin: 65px 0px;
	vertical-align: center;
	padding: 10px;
	width: 97%;
	position: absolute;
	top: 0px;
	left: 0px;
}
.topbar {
	margin: 25px 75px;
	width: 100%;
	position: absolute;
	top: 0px;
	left: 0px;
	margin: 0 auto 0 auto;			
}
.strip {
  	background: #C50;
	height: 10px;
}
.title .osu {
	font: bold italic 18px verdana, arial, sans-serif;
	position: absolute;
	top: 35px;
	left: 50px;
	z-index: 1;
	color: #CCC;
}

.title .osl {
	font: bold italic 40px verdana, arial, sans-serif;
	position: absolute;
	top: 43px;
	left: 100px;
	z-index: 3;
	color: #999;
}
.title .mirrors {
	font: bold italic 24px verdana, arial, sans-serif;
	position: absolute;
	top: 70px;
	left: 350px;
	z-index: 2;
	color: #CCC;
}


.title a {
	color: #000;
}
.title a:hover {
	text-decoration: none;
}

a { text-decoration: none; }
a:hover { text-decoration: underline; }

ul#tabnav {
	font: bold 11px verdana, arial, sans-serif;
	border-top: 1px solid #000;
	list-style-type: none;
	padding-bottom: 24px;
	margin: 0px;
}

ul#tabnav li {
	height: 22px;
	float: left;
	background-color: #eee;
	border: 1px solid #000;
	margin: -1px 4px 0 4px;
}

$CSSUL1 {
	border-top: 1px solid #C50;
	background-color: #C50;
}
$CSSUL2 {
	color: #000;
}

#tabnav a {
	float: left;
	display: block;
	color: #666;
	text-decoration: none;
	padding: 4px;
}

#tabnav a:hover {
	border-top: 1px solid #C50;
	margin: -1px 0px 0 0px;
	background: #C50;
	color: #000;
}

.main .footer .bwbar {
	display: block;
}

.main .footer .info {
	font: italic 10px verdana, arial, sans-serif;
	display: block;
" > $DIR/$CSS

# now html

for i in $INFO
do
	CLASS=`echo $i | cut -d"," -f1`
		echo "
		<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\" \"http://www.w3.org/TR/REC-html40/loose.dtd\">
		<HTML>
		 <HEAD>
		   <TITLE>ftp.osuosl.org :: Oregon State University Open Source Lab</TITLE>
		   <link rel=\"stylesheet\" type=\"text/css\" media=\"screen\" href=\"$RELATIVE_STYLE\" />
		</HEAD>
		<BODY id=\"$CLASS\">
		<div class=\"topbar\">
			<div class=\"strip\" >
				<div class=\"title\">
					 <a href=\"http://osuosl.org/\"> 
						<div class=\"osu\">Oregon State University</div>
						<div class=\"osl\"> Open Source Lab </div> 
						<div class=\"mirrors\">Mirrors</div>
					 </a>
				</div>
			</div>
			<ul id=\"tabnav\">
				$UL
			</ul>
		</div>
		<div class=\"main\">
		" > $DIR/$CLASS-$HTML
done
