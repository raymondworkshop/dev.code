#!/usr/bin/perl

## $Header$

# Don't use -w for disabling warnings when eval format.

#
#-----------------------------------------------------------------
# File Name:   subsCounter.pl
# Subsystem:   utility
# Manager:     tools
# Description: Compute numbers of subscriber.
# History:
#    09-Mar-2006  dche   creation
#-----------------------------------------------------------------
#

#use strict;

### globals ###
my (%crite_reg, %cname_reg, %res);
my (%hlrs, %counters, @counters);
my (%col, $nCols);
my ($opt_nc, $opt_cname);

### caches ###
my (%lac2vlr, %vlrinfo);

### subroutines ###
sub showUsage {
die <<EOF
Usage: subsCounter.pl [OPTIONS]

Compute numbers of sbuscriber.

Options:
    -l  <HLR Numbers>+               List of HLR numbers, separated by white 
                                       space; only CHECK the local hlr num is valid
    -i  <National code>              National Code
    [-n]                             Optional, flag of using canonical name of 
                                       counters
    -c  <Counter[{Custom name}]>+    List of counters, separated by white space.
                                       Each counter can have a optional custom
                                       name follow it. Custom name shall be 
                                       enclosed by braces

Note: The order of options is signicant.

This tool requires that:
0. Must be executed on a card on which the platform runs well;
1. TimesTen server on Primary SAM works well.

Example:
subsCounter.pl -l 861390170 -i 460 -n -c a{All Users} c l{Local Users}

Supported criterias:
------------------------
a                All subscribers (no constraints).
[c|d]            Attached/Detached
[i|n]            International/National users
[l|r]            Local/Roaming

Supported canonical counters:
------------------------
MSSHL01          a
MSSHL02          c
MSSHL03          l
MSSHL04          i

EOF
}

$opt_debug = 1;
sub dprint(@) {
	if ( defined $opt_debug ) { print "@_\n"; }
}

sub isValidNationalCode($;) {
	return ($_[0] =~ m/^\d{1,3}$/);
}

sub parseArgs () {
	if (scalar @ARGV < 6 || $ARGV[0] ne "-l") {
		showUsage
	}
	
	shift @ARGV;
	while ($ARGV[0] ne "-i") {
		showUsage if ($ARGV[0] =~ m/^-/);
		$hlrs{$ARGV[0]} = 1;
		showUsage if not defined (shift @ARGV);
	}
	shift @ARGV;
	die "ERR: Invalid National Code: \"$ARGV[0]\".\n" if not isValidNationalCode($ARGV[0]);
	$opt_nc = sprintf "%03d", $ARGV[0];
	shift @ARGV;
	if ($ARGV[0] eq "-n") {
		$opt_cname = 1;
		shift @ARGV;
	}
	showUsage if ($ARGV[0] ne "-c");
	shift @ARGV;
	my $prevCnt;
	my $cnts = join " ", @ARGV;
	$cnts =~ s/\s*}\s*/},/g;
	$cnts =~ s/\s*{\s*/{/g;
	my @args = split /,/, $cnts;
	for (@args) {
		# $_ is in the form "vx y z{any words}", vx, y and z are counters.
		my @cnts = split /\s/, $_;
		my ($c, $dname);
		while (defined $cnts[0]) {
			if ($cnts[0] =~ m/{/) {
				my $arg = join " ", @cnts;
				$arg =~ m/(\w){([\s\w]+)}/;
				($c, $dname) = ($1, $2);
			} else {
				$c = $cnts[0];
				shift @cnts;
			}
			if (!defined $counters{$c}) {
				$counters{$c} = {};
				push @counters, $c;
				$counters{$c}{dname} = $dname if defined $dname;
			}
			last if defined $dname;
		}
	}
	showUsage if (scalar keys %counters) == 0;
}

sub getActiveCCMIPs() {
    my @res = split /\n/, `BsPlSMProbe -f node -d | grep CCM | grep ACTIVE | nawk '{print \$1}'`;
    my @ips;
    for (@res) {
        my $ip = `ttIsqlCS -connstr dsn=systemconfigurationcs -v 1 -e "select ipaddressa from mscnodeconfig where mscnodenum=$_;quit" | sed -e "s/[<> ]//g"`;
        chomp $ip;
        $ips[++$#ips] = $ip;
    }
    \@ips
}

sub getLacFromCellId($;) {
	my $val = pack "H4", substr($_[0], 12, 4);
	unpack "S", $val;
}

sub initVlrInfo($;) {
	return if ( exists $vlrinfo{$_[0]});
	my $stmt = "SELECT vlr_num, description FROM spatial.msc_cfg_gsm_virtual_msc_vlr WHERE vmscvlridx=$_[0]";
	my $res = `ttIsqlCS -connstr dsn=mmappconfigdatacs -v 1 -e "$stmt;QUIT" | sed -e "s/[<>]//g" | sed -e "s/\^ //g" | sed -e "s/ \$//g"`;
	# TODO: catch...
	chomp $res;
#	print "$res\n";
	my ($vlrnum, $vlrdesc) = split /,/, $res;
#	print "$vlrnum\n";
	$vlrinfo{$_[0]}{num} = $vlrnum;
#	print "$vlrdesc\n";
	$vlrinfo{$_[0]}{desc} = $vlrdesc;
}

sub cellId2vlr($;) {
	my $lac = getLacFromCellId($_[0]);
	if (exists $lac2vlr{$lac}) { #cech, have got results
		return $lac2vlr{$lac} if defined $lac2vlr{$lac};
	}
	my $stmt = "SELECT vmscvlridx FROM spatial.msc_cfg_gsm_lac_cell WHERE lac=$lac GROUP BY vmscvlridx";
	my $vlridx = `ttIsqlCS -connstr dsn=mmappconfigdatacs -v 1 -e "$stmt;QUIT" | sed -e "s/[<> ]//g"`;
	# TODO: catch...
	chomp $vlridx;
	initVlrInfo $vlridx if not exists $vlrinfo{$_[0]};
	$lac2vlr{$lac} = $vlridx;
}

sub registerCriteria ($$$$$;) {
    $crite_reg{$_[0]}{buddy} = $_[1]; #only check function
    $crite_reg{$_[0]}{getCols} = $_[2];
    $crite_reg{$_[0]}{getConds} = $_[3];
    $crite_reg{$_[0]}{postCheck} = $_[4];
}

sub registerCanonName($$;) {
	return if not defined $crite_reg{$_[0]};
	$cname_reg{$_[0]} = $_[1];
}

sub printPart ($;) {
	my $topfmt = "format HEADER_STDOUT =
--------------------------------------------------------------------------------
@>>>>>>>>>  ";
	my $subtopfmt = 'Counter';
	my $resfmt = "format STDOUT =
@>>>>>>>>>  ";

	my $subresfmt = '$cntName';
	my $i = 0;
	for (@{$_[0]}) {
		chomp;
		$topfmt .= "@<<<<<<<<< ";
		$subtopfmt .= ", " . $vlrinfo{$_}{desc};
		$resfmt .= "@<<<<<<<<< ";
		$subresfmt .= ", " . "\$res[$i]";
		$i++;
	}
	$topfmt .= "\n" . $subtopfmt . "\n.";
	$resfmt .= "\n" . $subresfmt . "\n.";
#	dprint $topfmt;
#	dprint $resfmt;
	my ($cntName, $cnt, @res);
	eval $topfmt;
	eval $resfmt;
	$^ = HEADER_STDOUT;
	$~ = STDOUT;
	$- = 0;	# force to print top.
	for (@counters) {
		if (defined $opt_cname && defined $cname_reg{$_}) {
			$cntName = $cname_reg{$_};
		} elsif (defined $counters{$_}{dname}) {
			$cntName = $counters{$_}{dname};
		} else { $cntName = $_ }
			
		$cnt = $_;
		
		@res = ();
		for (@{$_[0]}) {
			if (defined $res{$cnt}{$_}) {
				push @res, $res{$cnt}{$_}
			} else {
				push @res, 0;
			}
		}
		write;
	}
}

sub printAll () {
	my ($qryDate, $switchName);

	format STDOUT=
@|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
                      "VLR Subscriber Query Results"
--------------------------------------------------------------------------------
Query Time: @<<<<<<<<<<<<<<<<<<<<<<<<<<
            $qryDate
Switch Name: @<<<<<<<<<<<<<<<<<<<<<<<<<
             $switchName
.
	$qryDate = localtime;
	$switchName = `hostname | cut -d_ -f 1`;
	write;

	my $nvlr = 0;
	my @vlr;
	for (keys %vlrinfo) {
		push @vlr, $_;
		$nvlr++;
		next if $nvlr < 6;
		printPart \@vlr;
		@vlr = ();
		$nvlr = 0;
	}
	printPart \@vlr if $nvlr != 0;
}

### subroutines for criterias ###
sub cd_getCols(\%;) {
	if (! exists $_[0]->{"IMSIDETACHFLAG"}) {
		$_[0]->{"IMSIDETACHFLAG"} = ++$nCols;
		push @{$_[0]->{__cols__}}, "IMSIDETACHFLAG";
	}
}

sub c_getConds(\@;) {
    push @{$_[0]}, "IMSIDETACHFLAG<128"
}

sub d_getConds(\@;) {
    push @{$_[0]}, "IMSIDETACHFLAG>127"
}

sub lr_getCols(\%;) {
	if (! exists $_[0]->{HLRNUMBER}) {
		$_[0]->{HLRNUMBER} = ++$nCols;
		push @{$_[0]->{__cols__}}, "HLRNUMBER";
	}
}

sub i_getConds(\@;) {
	my $c2 = reverse(substr($opt_nc, 0, 2));
	my $c3 = substr($opt_nc, 2, 1);
	# FIXME: ugly solution. Also assume that bearer code is always 0.
	# Mofidy here after TT6 is used.
	push @{$_[0]}, "(NOT (imsi>=0x${c2}0${c3}000000000000 AND imsi<=0x${c2}0${c3}FFFFFFFFFFFF))" # OR (imsi>=0x${c2}1${c3}000000000000 AND imsi<=0x${c2}1${c3}FFFFFFFFFFFF) OR (imsi>=0x${c2}2${c3}000000000000 AND imsi<=0x${c2}2${c3}FFFFFFFFFFFF) OR (imsi>=0x${c2}3${c3}000000000000 AND imsi<=0x${c2}3${c3}FFFFFFFFFFFF) OR (imsi>=0x${c2}4${c3}000000000000 AND imsi<=0x${c2}4${c3}FFFFFFFFFFFF) OR (imsi>=0x${c2}5${c3}000000000000 AND imsi<=0x${c2}5${c3}FFFFFFFFFFFF) OR (imsi>=0x${c2}6${c3}000000000000 AND imsi<=0x${c2}6${c3}FFFFFFFFFFFF) OR (imsi>=0x${c2}7${c3}000000000000 AND imsi<=0x${c2}7${c3}FFFFFFFFFFFF) OR (imsi>=0x${c2}8${c3}000000000000 AND imsi<=0x${c2}8${c3}FFFFFFFFFFFF) OR (imsi>=0x${c2}9${c3}000000000000 AND imsi<=0x${c2}9${c3}FFFFFFFFFFFF))";
}

sub n_getConds(\@;) {
	my $c2 = reverse(substr($opt_nc, 0, 2));
	my $c3 = substr($opt_nc, 2, 1);
	#FIXME: ugly solution.
	push @{$_[0]}, "((imsi>=0x${c2}0${c3}000000000000 AND imsi<=0x${c2}0${c3}FFFFFFFFFFFF))" # OR (imsi>=0x${c2}1${c3}000000000000 AND imsi<=0x${c2}1${c3}FFFFFFFFFFFF) OR (imsi>=0x${c2}2${c3}000000000000 AND imsi<=0x${c2}2${c3}FFFFFFFFFFFF) OR (imsi>=0x${c2}3${c3}000000000000 AND imsi<=0x${c2}3${c3}FFFFFFFFFFFF) OR (imsi>=0x${c2}4${c3}000000000000 AND imsi<=0x${c2}4${c3}FFFFFFFFFFFF) OR (imsi>=0x${c2}5${c3}000000000000 AND imsi<=0x${c2}5${c3}FFFFFFFFFFFF) OR (imsi>=0x${c2}6${c3}000000000000 AND imsi<=0x${c2}6${c3}FFFFFFFFFFFF) OR (imsi>=0x${c2}7${c3}000000000000 AND imsi<=0x${c2}7${c3}FFFFFFFFFFFF) OR (imsi>=0x${c2}8${c3}000000000000 AND imsi<=0x${c2}8${c3}FFFFFFFFFFFF) OR (imsi>=0x${c2}9${c3}000000000000 AND imsi<=0x${c2}9${c3}FFFFFFFFFFFF))";
}

sub decodeHlrNumber($;) {
	my $hlr = substr($_[0], 4, 10);
	$hlr = reverse(substr($hlr, 0, 2)) . reverse(substr($hlr, 2, 2)) . reverse(substr($hlr, 4, 2)) . reverse(substr($hlr, 6, 2)) . reverse(substr($hlr, 8, 2));
}

sub l_postCheck(\@;) {
	my $hlr = $_[0]->[$col{HLRNUMBER} - 1];
	for (keys %hlrs) {
		if (decodeHlrNumber($hlr) eq $_) {
			return 1;
		}
	}
	return 0;
}

sub r_postCheck(\@;) {
	my $hlr = $_[0]->[$col{HLRNUMBER} - 1];
	for (keys %hlrs) {
		if (decodeHlrNumber($hlr) eq $_) {
			return 0;
		}
	}
	return 1;
}

### main ###
# initialize criterias.
$crite_reg{"__cols__"} = ();

registerCriteria "a", "", "", "", "";
registerCanonName "a", "MSSHL01";
registerCriteria "c", "d", "cd_getCols", "c_getConds", "";
registerCanonName "c", "MSSHL02";
registerCriteria "d", "c", "cd_getCols", "d_getConds", "";
registerCriteria "l", "r", "lr_getCols", "", "l_postCheck";
registerCanonName "l", "MSSHL03";
registerCriteria "r", "l", "lr_getCols", "", "r_postCheck";
registerCriteria "i", "n", "", "i_getConds", "";
registerCanonName "i", "MSSHL04";
registerCriteria "n", "i", "", "n_getConds", "";

parseArgs;

my $ccms = getActiveCCMIPs;

my (@cond, $conds, @c, $stmt);
my $noCrite = 1;
for (keys %counters) {# the return haxi, no array, array is ok
    #1. pass through each criteria, construct the query statement.
	$stmt = "SELECT count(imsi), cellglobalid";
    %col = @cond = ();
	$nCols = 2;
	$conds = $_;
    @c = split //, $conds;
	my $validCounter = 1;
    for (@c) {
        next if ($_ eq 'a');
        if (!defined $crite_reg{$_}) {
        	$validCounter = 0;
        	printf STDERR "WRN: Unrecognized counter: \"$_\" of $conds, ignored.\n";
        	next	
        }
        my $name = $crite_reg{$_}{buddy};	# get exclusive criterias
		if ($name ne "" and $conds =~ m/$name/) {
        	$validCounter = 0;
			printf STDERR "WRN: confilcting query conditions: \"$_\" and \"$name\", ignored.\n";
			next;
		}
		$noCrite = 0;
		$name = $crite_reg{$_}{getCols};
		&$name(\%col) if ($name ne "");
		$name = $crite_reg{$_}{getConds};
        &$name(\@cond) if ($name ne "");
    }
    next if not $validCounter;
    if ($nCols > 2) {
        $stmt = $stmt . ", " . join(", ", @{$col{__cols__}}) . " FROM vlr_mobility";
    } elsif ($noCrite and !($conds =~ m/a/)) {
		# if all criterias are ignored due to conflicting, don't try to
		# execute a plain query.
		next;
	} else {
		$stmt = $stmt . " FROM vlr_mobility";
	}
    if (scalar @cond > 0) {
        $stmt = $stmt . " WHERE " . join(" AND ", @cond);
    }
    $stmt = $stmt . " GROUP BY cellglobalid";
    if ($nCols > 2) {
        $stmt = $stmt . ", " . join(", ", @{$col{__cols__}});
    }
    $stmt = $stmt . "; QUIT";
#    dprint "$stmt";
    #2. query all Active CCM cards, store the data into a temp file.
    qx(echo "" > /tmp/imsi_qry_res);
    for (@$ccms) {
        qx(ttIsqlCS -connstr "dsn=wirelessdatacs; ttc_server=$_" -v 1 -e "$stmt;QUIT" | sed -e "s/[<>]//g" | sed -e "s/\^ //" | sed -e "s/ \$//" >> /tmp/imsi_qry_res);
    }
    #3. for each criteria that needs post check, pass each line of results through it.
    my (%sum, $ok);
    open QERY_RES, "/tmp/imsi_qry_res";
    while (<QERY_RES>) {
    	chomp;
		next if m/^$/;
    	my @line = split /, /, $_;
    	$ok = 1;
	    for (@c) {
			next if ($_ eq 'a');
	        my $name = $crite_reg{$_}{postCheck};
	        $ok = &$name(\@line) if ($name ne "");
	    }
	    if ($ok) {
	    	$sum{$line[1]} += $line[0];
	    }
	}
	close QERY_RES;
    #4. for each cellid, get its vlr number, sum up again.
    $res{$conds} = ();
    my $rref = \$res{$conds};
    for (keys %sum) {
    	my $vlr = cellId2vlr($_);
    	if (defined $res{$conds}{$vlr}) {
    		$res{$conds}{$vlr} += $sum{$_};
    	} else { $res{$conds}{$vlr} = $sum{$_}; }
    }
}

# show the results.
printAll;
