#!/usr/bin/python
# hitstats.py
# originall by cshields
# heavily redone by marineam
# watches an apache log and provides a funky rss feed
# of the  city/country location of the latest hit
import re, time, os, sys, socket, getopt, GeoIP
import BaseHTTPServer

if socket.gethostname() == "ftp-osl":
        HOSTS = [ 'localhost',
                'http://ftp-chi.example.org:8000/' ]
else:
        HOSTS = [ 'localhost' ]

host_index = 0;

# location of the apache log to watch
LOGDIR = '/var/log/apache2/transfer'

# the location of the GeoLiteCity.dat (or equiv) file
GEODATA = "/usr/local/share/GeoIP/GeoLiteCity.dat"
gi = GeoIP.open(GEODATA, GeoIP.GEOIP_STANDARD)

current_locale = ""
current_lat = ""
current_long = ""
st_old = None
log = None

re_ip = re.compile(r'\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b')

class RssHandler (BaseHTTPServer.BaseHTTPRequestHandler):
    def do_HEAD(self):
        self.send_response(200)
        self.send_header("Content-type", "text/xml")
        self.end_headers()

    def do_GET(self):
        """Respond to a GET request."""
        global host_index;
        if HOSTS[host_index] == "localhost":
                self.send_xml()
        else:
                self.send_redirect(HOSTS[host_index])

        host_index = (host_index + 1) % len(HOSTS)

    def send_redirect(self, host):
        self.send_response(302)
        self.send_header("Location", host)
        self.send_header("Content-type", "text/xml")
        self.end_headers()

    def send_xml(self):
        if self.update_ip() == 1:
                # Try again one more time
                self.update_ip()

        rss = """<rss version="2.0"><channel>
        <title>Latest download locale</title>
        <link>http://%s:%d/</link>
        <pubDate>%s</pubDate>
        <item><title>%s</title></item>
        <item><title>%s</title></item>
        <item><title>%s</title></item>\n</channel></rss>\n""" % (
                socket.getfqdn(), port, time.asctime(),
                current_locale, current_lat, current_long)

        self.send_response(200)
        self.send_header("Content-type", "text/xml")
        self.end_headers()
        self.wfile.write(rss)

    def update_geo(self, ip):
        global current_locale
        global current_lat
        global current_long
        try:
            gir = gi.record_by_addr(ip)
        except:
            self.log_error("Failed to get geo data for ip '%s'", ip)
        else:
            if type(gir['city']) == str and type(gir['country_name']) == str:
                current_locale = gir['city'] + ", " + gir['country_name']
                current_lat = str(gir['latitude'])
                current_long = str(gir['longitude'])
            else:
                self.log_error("Failed to get city/coutnry info for ip '%s'",
                               ip)

    def update_ip(self):
        global st_old
        global log

        logfile = "%s/%s.log" % (LOGDIR, time.strftime("%Y%m%d"));

        st_new = os.stat(logfile)
        if not log or not st_old or st_new.st_ino != st_old.st_ino:
            if log:
                log.close()
            log = open(logfile, 'r')
            st_old = st_new
        elif st_new.st_size == st_old.st_size:
            # log has not updated, don't bother reading
            return 0

        # seek to 1 byte before the end of the file
        try:
            log.seek(-1, 2)
        except IOError:
            self.log_error("Empty logfile!")
            return 0

        c = None
        while c != '\n':
            # Seek two chars back and read 1
            log.seek(-2, 1)
            c = log.read(1)
        line = log.readline()
        match = re_ip.search(line)
        if match:
                ip = match.group()
                self.update_geo(ip)
                return 0
        else:
            self.log_error("Failed to find ip address in line '%s'",line)
            return 1

def run_server(port):
    httpd = BaseHTTPServer.HTTPServer(("", port), RssHandler)
    sys.stderr.write("Server Start: %s\n" % time.asctime())
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        pass
    sys.stderr.write("Server Stop: %s\n" % time.asctime())

def usage():
    print "hitstats.py --port <port number> [--log <log file>]"

def main():
    global port
    port = None
    log = None

    try:
        opts, args = getopt.getopt(sys.argv[1:], "p:l:h",
                                   ["port=", "log=", "--help"])
    except getopt.GetoptError:
        usage()
        sys.exit(1)

    for (opt, arg) in opts:
        if opt in ("-p", "--port"):
            port = int(arg)
        if opt in ("-l", "--log"):
            log = arg
        if opt in ("-h", "--help"):
            usage()
            sys.exit(0)

    if not port:
        sys.stderr.write("No port given\n")
        usage()
        sys.exit(1)

    if log:
        logfd = open(log, 'a+', 0)
        sys.stderr.flush()
        os.dup2(logfd.fileno(), sys.stderr.fileno())

    run_server(port)

if __name__ == '__main__':
    main()
