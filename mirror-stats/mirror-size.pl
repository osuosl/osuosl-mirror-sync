#!/usr/bin/perl -w

use strict;

my $SHOST = "ftp-osl";      # host to get the tree sizes from
my $RPATH = "/data/mirror/rrd"; # path to rrd files
my $TZ = "UTC";         # syslog does not include timezone

use Data::Dumper;
use RRDs;
use POSIX qw(tzset);
$ENV{TZ} = $TZ;
POSIX::tzset();

my $err;
while (<>) {
    my $l = $_;
    s/^(\w{3} {1,2}\d{1,2} \d{2}:\d{2}:\d{2})\s+//
        or print STDERR "malformed date at line: $l\n" and next;
    my $date = $1;

    s/^(\S+)\s+//
        or print STDERR "malformed host at line: $l :: $_\n" and next;
    my $host = $1;

    s/^mirror:\s+//
        or print STDERR "not a mirror record at line: $l\n" and next;

    s/^(\S+)\s+(\S+)\s+(\S+)\s*//
        or print STDERR "malformed log entry at line $l\n" and next;

    my $type = $1;
    my $event = $2;
    my $tree = $3;
    my $extra = $_;
    chomp $extra;

    if (not ($type eq "check" and $event eq "size")) {
        next;
    }
    if (not $extra =~ /^\d+$/) {
        print STDERR "malformed size log entry at line $l\n";
        next;
    }

    my $date_e = `date -d "$date $TZ" "+\%s"`;
    chomp $date_e;

    if (not -e "$RPATH/$tree.rrd") {
        my $start_e = $date_e - 1;
        RRDs::create("$RPATH/$tree.rrd", "--start=$start_e",
            "--step=21600", "DS:size:GAUGE:43200:0:U",
            "RRA:MIN:0.5:1:1200", "RRA:MAX:0.5:1:1200",
            "RRA:AVERAGE:0.5:1:1200" );
        $err = RRDs::error;
        die "ERROR while creating $tree.rrd: $err\n" if $err;
    }

    # Pass over old values (If a log is being reparsed)
    my $last = RRDs::last("$RPATH/$tree.rrd");
    next if ($last >= $date_e);

    RRDs::update("$RPATH/$tree.rrd", "$date_e:$extra");
    $err = RRDs::error;
    die "ERROR while updating $tree.rrd: $err\n" if $err;
}

