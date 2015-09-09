#!/usr/bin/perl -w

#
# dbmig_gen.pl.
#
# A template based database migration scripts generator.
# Part of the code borrowed from ttCompSchema written by vpatel.
#
# Known problems;
#	1. Depend on some bizarre convetions and file formats.
#	2. More thorough Schema comparing, and more formal output, or even a
#		new argument for schema comparing.
#	4. Can't handle table DefaultAndRanges.
#	5. Add sanity checking before upgrade to the generated scripts.
#
#
# Revision history:
#
#	2005-10-24		dche		created.
#	2005-11-21		LiKe		complete insert table part.
#	2006-09-12		zhangh		improvements:
#                                 1. Generate script for DynamicDB separately;
#                                 2. Support executing user provided scripts by
#                                   change the script template only.
#	2006-10-18		dche		create indexes when create/re-create tables.
#	2006-10-19		zhangh		support extracting DB schemas from live WSS.
#	2006-11-13		dche		support compare two live databases.
#

use strict;

#------PARAMETERS------#
my ( $opt_help, $opt_version, $opt_debug, $opt_diff, $opt_olddir, $opt_hint, $opt_ttcserver, $opt_newdir );

#------GLOBAL DATA STRUCTURE------#
# [n|o]dbs
#	dbsName => tableName
#				reference to a hash
#					columns = (columnName:columnDescription)+
#					primaryKey => pk_col_name [, pk_col_name]
#					foreignKeys
#						referenced table => col:refCol
#					indexes
# [n|o]depends
#
# hints
#	dbsname => tbls
#				_prevName => a removed table name
#				colname => n:oldcolname
#				colname => v:default value
#				colname => u:update value	# TODO: more accurate description...
#
my ( $ndbs, $odbs, %odepends, %ndepends, $newrel, $oldrel, $hints );
my ( %removeonly, %addonly, @newcol, %recreate );

#
# %repDbs -- hash of DBs whose replication deamon will be stoppped.
# %tmpTbls -- cache of all temprary tables used during migration.
#
my ( %repDbs, %tmpTbls );

my @samdb = ( "SystemConfiguration",
				"EmsData",
				"SS7Configuration",
				"CallProcessing",
				"MMAppConfigData",
				"SubscriberData",
			);
my @dynamicdb = ( "DynamicDB", );
my @ccmdb = ( "WirelessData", );
my @ddmdb = ( "DDFData", );

# mode of the target. Living DB or database directory of installation package.
my $g_target;

#------------SUBROUTINES------------#
sub usage() {
die <<EOS;
Usage: dbmig_gen [OPTIONS]... <-b TTC_SERVER | DATABASEIDR>

Generate database migration scripts for release upgraging.
New scripts will be put in the current work directory. If there are
files with the same name exist, the old files will be replaced.

	-h, --help                  Print this help, then exit
	-v, --version               Print version number, then exit
	-d, --debug                 Print debug information
	-o, --olddir DATABASEDIR    The source is a database directory.
	                              When omitted, the running Database
	                              will be used.
	-i, --hint FILENAME         Hint file name.
	-b, --db TTC_SERVER         The target is a living database. Specify the
	                              IP addreass, or "localhost" for local machine.
	-n, --newdir DATABASEDIR    The target is a database directory. Specify the
	                              directory name.
EOS
}

sub version() {
die <<EOS;
dbmig_gen v0.3
A database migration script generator.

Copyright (C) 2005-2006 Alcatel Shanghai Bell, Inc.
EOS
}

sub dprint(@) {
	if ( $opt_debug ) { print STDERR "@_\n"; }
}

# get release number of Database schema.
sub getDBRelease($$;) {
	my $rel;
	my ($where, $target) = @_;

	my $paramname = "Database_Schema_Data_Version";
	if ( $target eq "DIR" ) { # Get it from Database directory.
		$rel = `grep $paramname $where/SystemConfiguration/InsertConfigParamsTable.bulk | cut -d, -f8`;
		chomp $rel;
		# remove \"
		$rel =~ s/\"|\s+//g;
	} else { # Get from running Database.
		$rel = queryDB($where, "SystemConfiguration", "select PARAMVALUE from configparams where PARAMNAME=\'Database_Schema_Data_Version\'");
		$rel =~ s/[\s]//g;
	}
	$rel;
}

sub getDBCName($;) {
	if ( $_[0] =~ m/SYSTEMCONFIGURATION/i ) {
		"SystemConfiguration";
	} elsif ( $_[0] =~ m/EMSDATA/i ) {
		"EmsData";
	} elsif ( $_[0] =~ m/MMAPPCONFIGDATA/i ) {
		"MMAppConfigData";
	} elsif ( $_[0] =~ m/SS7CONFIGURATION/i ) {
		"SS7Configuration";
	} elsif ( $_[0] =~ m/CALLPROCESSING/i ) {
		"CallProcessing";
	} elsif ( $_[0] =~ m/DYNAMICDB/i ) {
		"DynamicDB";
	} elsif ( $_[0] =~ m/SUBSCRIBERDATA/i ) {
		"SubscriberData";
	} elsif ( $_[0] =~ m/WIRELESSDATA/i ) {
		"WirelessData";
	} elsif ( $_[0] =~ m/DDFDATA/ ) {
		"DDFData";
	} else { "" }
}

# query the live TimesTen DB, and return the list of results or the first value.
sub queryDB($$$;) {
	my ($ttcserver, $db, $stmt) = @_;
	my $res;

	if ( $ttcserver eq "" ) {
		$res = `ttIsql -connstr dsn=${db}Dir -v 1 -e \"$stmt; quit\"`;
	} else {
		$res = `ttIsqlCS -connstr \"dsn=${db}CS;ttc_server=$ttcserver\" -v 1 -e \"$stmt; quit\"`;
	}

	chomp $res;
	$res =~ s/<\s*|\s*>//g;
	my @reslist = split /\n/, $res;

	return @reslist unless defined wantarray;
	return (wantarray) ? (@reslist) : ($reslist[0])
}

sub getKeyName($$$$$) {
	my ($colnum, $colName, $columnName, $i);
	my ($ttcserver, $curDb, $tblId, $columnId, $nums) = @_;

	$columnName = "";
	for ($i=0; $i < $nums; $i++) {
		$colnum = pack "H4", substr ( $columnId, $i * 4, 4);
		$colnum = unpack "n", $colnum;
		$colName = queryDB($ttcserver, $curDb, "select COLNAME from SYS.COLUMNS where ID = $tblId and COLNUM = $colnum");

		if ( $columnName eq "") {
			$columnName = $colName
		} else { $columnName .= "," . $colName; }
	}
	$columnName;
}

# get database schemas from living Database
sub getSchemaFromDB($;) {
	my ( $dblist, %dbs );
	my ( $tblist, @tblist, $curTbl, $tblId, $tbl, $tblDesc, @tblDesc, @colDesc,$prilist, @prilist);
	my ( @fkList, @foreignKey);

	my $ttcserver = $_[0];

	if ( $_ eq "SAM" ) { $dblist = \@samdb; }
	elsif ( $_ eq "CCM" ) { $dblist = \@ccmdb; }
	elsif ( $_ eq "DynamicDB" ) { $dblist = \@dynamicdb; }
	else { $dblist = \@ddmdb; }

	for (@$dblist) {
		my $curDb = $_;

		@tblist = queryDB($ttcserver, $curDb, "select TBLNAME from SYS.TABLES where TBLOWNER='SPATIAL' order by TBLNAME");
		foreach (@tblist) {
			$curTbl = $_;
			print "Examning $curTbl on [$ttcserver]...\n";

			$tbl->{"NeedReplication"} = `grep $curTbl /opt/Spatial/msc/active/installation/tables.${curDb}.replication`;

			$tblId = queryDB($ttcserver, $curDb, "select TBLID from SYS.TABLES where TBLNAME = '$curTbl'");

			# get primary keys
			$prilist = queryDB($ttcserver, $curDb, "select KEYCOLS, KEYCNT from SYS.INDEXES where IXNAME='$curTbl'");
			if ( defined $prilist and $prilist ne "" ) {
				my $priName ;

				@prilist = split (/, /, $prilist);
				$priName = getKeyName($ttcserver, $curDb, $tblId, $prilist[0], $prilist[1] );
				$priName =~ s/,/ /g;
				$tbl->{"primaryKey"} = $priName;
			}

			# TODO: We use the undocumented theory of TimesTen to find foreign
			#		keys of tables. Add release protection here. After
			#		TimesTen r6.0 is used, we have the official tool ttSchema
			# 		to get complete scheam information.
			#
			# THEORY:
			# the foreign key information of a TimesTen table can be found in
			#   table SYS.INDEXES.
			# columns TBLID, IXNAME, IXID, SYS6, KEYCOLS, KEYCNT and ISPRIMARY
			#   of the talbe are used.
			# foreign key indexes of a table have the name pattern
			#   "TTFOREIGN_*", and are associated with the table by TBLID.
			#   foreign key columns defined in an foreign key dependency, are
			#   similar to the primary keys, can be found by KEYCOLS and KEYCNT
			#   columns of the foreign key index.
			# the referenced table and columns, can by found by traversing a
			#   linked list of indexes. All foregin key indexes that
			#   reference to the same table, along with the primary index of the
			#   table, are linked with the column IXID of these indexes. The
			#   undocumented column SYS6 stores the IXID of previous index in
			#   the list.
			# The ISPRIMARY column indicates whehter an index is a primary index
			#   (index automatically created on primary keys) or not. Another
			#   clue for deciding primary index is the IXNAME.
			#

			# get all foreign key dependency definitions of the tale.
			@fkList = queryDB($ttcserver, $curDb, "select SYS6 from SYS.INDEXES where TBLID = $tblId and IXNAME like 'TTFOREIGN_%'");
			foreach (@fkList) {
				my $sys6 = $_;
				my ( $keylist, @keylist, $key, $curtblId, $column, @column, $columnname, $fcolumn, @fcolumn, $fcolumnname);

				# get foreign key columns.
				$column = queryDB($ttcserver, $curDb, "select KEYCOLS, KEYCNT from SYS.INDEXES where TBLID = $tblId and SYS6 = $sys6");
				@column = split /, /, $column;
				$columnname = getKeyName($ttcserver, $curDb, $tblId, $column[0], $column[1]);

				# traverse index list.
				my $ispri = "00";
				while ( $ispri eq "00" ) {
					$keylist = queryDB($ttcserver, $curDb, "select IXNAME, TBLID, SYS6, ISPRIMARY from SYS.INDEXES where IXID = $sys6");
					@keylist = split /, /, $keylist;

					$key = $keylist[0];
					$key =~ s/\s+$//g;

					$ispri = $keylist[3];
					$sys6 = $keylist[2];
					$curtblId = $keylist[1];

					# although it is rare, we did find a loop of some indexes.
					# at this case, there is IXNAME neither a table name, nor
					#   TTFOREIGN_*.
					next if ( $key =~ m/TTFOREIGN_\d*/ );
					# terminate the search forcely.
					$ispri = "01";
				}

				# get referenced columns from the primary index of referenced table.
				$fcolumn = queryDB($ttcserver, $curDb, "select KEYCOLS, KEYCNT from SYS.INDEXES where TBLID = $curtblId and SYS6 = $sys6");
				@fcolumn = split /, /, $fcolumn;
				$fcolumnname = getKeyName($ttcserver, $curDb, $curtblId, $fcolumn[0], $fcolumn[1]);

				# get table name from SYS.TABLES
				$key = queryDB($ttcserver, $curDb, "select TBLNAME from SYS.TABLES where TBLID=$curtblId");
				$key =~ s/\s+$//g;

				$tbl->{"foreignKeys"}{$key} = "\($columnname\) REFERENCES SPATIAL.${key}\($fcolumnname\)";

				$odepends{$curDb}{$key}{$curTbl} = 1;
				$odepends{$curDb}{$curTbl}{"refTables"}{$key} = 1;
			}

			# TODO: get the non-PK index definitions.
			# get column definitions.
			$tblDesc = `ttIsqlCS -connstr \"dsn=${curDb}CS; ttc_server=$ttcserver\" -v 1 -e \\
				\"desc $curTbl; quit\"`;
			chomp ($tblDesc);
			$tblDesc =~ s/^\s*//;
			@tblDesc = split (/\n/, $tblDesc);
			foreach (@tblDesc) {
				s/^\s*//;
				next if ( /^Table / );
				next if ( /^\s*Columns:\s*$/ ) ;
				last if ( /^\s*$/ );

				@colDesc = split();

				$_ = shift @colDesc;
				if ($_ =~ /^\*/) {
					$_ = $';
				}
				if ($colDesc[0] eq "INTEGER") {
					$colDesc[0] = "INT";
				}
				push @{ $tbl->{"columns"} }, "$_" . ":" . join " ", @colDesc;
			}
			$dbs{$curDb}{$curTbl} = $tbl;
			$tbl = {};
		}
	}
	\%dbs;
}

# get DB schema from DataBase DDL files in the installation package
sub getSchemaFromWS($;) {
	my ($dblist, $basedir, %dbs);
	my ( $curTbl, $tbl, @colDef, $keys, $needRep );

	if ( $_ eq "SAM" ) {
		my @dblist = @samdb;
		$dblist = \@dblist;
		push @$dblist, "Performance";
#		push @$dblist, "DefaultsAndRanges";
	}
	elsif ( $_ eq "CCM" ) { $dblist = \@ccmdb; }
	elsif ( $_ eq "DynamicDB" ) { $dblist = \@dynamicdb; }
	else { $dblist = \@ddmdb; }

	$basedir = $_[0];

	for (@$dblist) {
		# Performance tables and DefaultsAndRanges belong to EmsData DB
		my $curDb;
		if ( $_ eq "Performance" || $_ eq "DefaultsAndRanges" ) {
			$curDb = "EmsData"
		} else { $curDb = $_ }

		$needRep = 1;
		my $sqlname;
		if ($_ eq "Performance") {
			$sqlname = "SystemPerformance";
			$needRep = 0;
		} elsif ( $_ eq "DynamicDB" ) {
			$sqlname = "Dynamic";
		} else { $sqlname = $_; }

		$sqlname = "$basedir/$_/create" . ($sqlname) . "DB.sql";
		if ( $_ eq "DefaultsAndRanges" ) {
			$sqlname = "$basedir/EmsData/DefaultsAndRanges.sql";
		}
		open SQLFH, "<" . $sqlname or die "Can not open file $sqlname: $!";

		local $/ = ";\n";
		for (<SQLFH>) {
			my @desc = ();

			chomp;
			# remove E: and comments like /* */ in createEmsDataDB.sql
			s/E:[^\n]*\n//g;
			s/\/\*(.*?)\*\///g;
			s/\n//g;	# remove line feeds
			s/\((\D+)\s+/,$1 /;	# split "create table" from the first field
			s/\(\s+(\d+)\s+\)/\($1\)/g;	# remove spaces in "(0-9)"
			s/\)\s*$//g; # remove last parens
			while (	s/\(([^\)\s,]+)\s+,/\($1#/ ) {
				;  # replace commas in a key list with qm.
			}
			s/\s+/ /g;	# remove excessive spaces

			if ( /^CREATE (UNIQUE )?INDEX/i ) {
                tr/a-z/A-Z/;
                # now the $_ is in the format "CREATE (UNIQUE)?INDEX ON SPATAL.TABLENAME, COL1, .., COLn"
				@desc = split /,/;
				$desc[0] =~ m/CREATE (UNIQUE )?INDEX SPATIAL\.([^\s]+) ON SPATIAL\.([^\s]+)/;
				next if not defined $dbs{$curDb}{$3};

				my ($tblName, $indexName) = ($3, $2);
				shift @desc;
				for (@desc) {
					s/\s//g;
					$dbs{$curDb}{$tblName}->{"indexes"}{$indexName}{$_} = 1;
				}
				next
			}

			@desc = split /,/;
			for (@desc) {
				s/^\s+|\s+$//g; # remove leading and trailing spaces.

				if ( /^CREATE TABLE/i ) { 
					/SPATIAL.([^:]+)\s*$/;
					$curTbl = $1;
					# store the case sensitive name too.
					$tbl->{"CSName"} = $curTbl;
					$tbl->{"NeedReplication"} = $needRep;
					$curTbl =~ tr/a-z/A-Z/;
					next;
				}
				next if ( !defined $curTbl );   # skip noises.
				next if (/^$/);
				tr/a-z/A-Z/;
				if ( /^PRIMARY KEY/ ) { # primary key
					# we assume the SQL file are syntax correct.
					# So do't check whether $tbl->{"primaryKey"} has been defined.

					s/#/ /g;  # remove dots in a key list
					s/\s+/ /g;	# remove excessive spaces
					/\(([^\)]+)\)/;
					$keys = $1;
					$keys =~ s/^\s+|\s+$//g;
					$tbl->{"primaryKey"} = $keys;
					next;
				}
				if ( /^FOREIGN KEY/ ) { # foreign key
					my $fk = $';
					$fk =~ s/#/,/g;
					s/\s+/ /g;	# remove excessive spaces
					$fk =~ s/^\s+|\s+$//g;
					$fk =~ s/\s+\)/\)/g;
					$fk =~ m/REFERENCES SPATIAL\.([^\(\s]+)\s?\(/;
					$tbl->{"foreignKeys"}{$1} = $fk;
					if ( $_[0] eq "old" ) {
						$odepends{$curDb}{$1}{$curTbl} = 1;
						$odepends{$curDb}{$curTbl}{"refTables"}{$1} = 1;
					}
					next;
				}
				@colDef = split();
				$_ = shift @colDef;

				if ( $colDef[$#colDef] eq "KEY" ) {
					# found PRIMARY KEY syntax in column definition.
					# PRIMARY KEY must be at the tail of column definition.
					if ( not defined $tbl->{"primaryKey"} ) {
						$tbl->{"primaryKey"} = $_;
					}

					$#colDef -= 2;	# remove "PRIMARY" and "KEY"
				}

				push @{ $tbl->{"columns"} }, "$_" . ":" . join " ", @colDef;
			}
			if ( defined $curTbl and $curTbl ne "GENSCHEMAINCLUDE"
				and exists $tbl->{"columns"} )
			{
				$dbs{$curDb}{$curTbl} = $tbl;
				$tbl = {};
				undef $curTbl;
			}
		}
	}
	close SQLFH;
	\%dbs;
}

sub getDefaultValueFromMetadata($$$) {
	my ($db, $tbl, $colname) = @_;
	$db = getDBCName $db;
	my $fn;
	my $txt = "";
	# FIXME: How difficult to write a generic regexp for *grep!!!
	$fn = "$opt_newdir/$db/" . `ls $opt_newdir/$db | grep -i "^\\(create\\)*$tbl\[^0-9\]*.txt\$"`;
	print $fn;
	chomp $fn;
	return $txt if not -f $fn;
	open TXTFH, "<" . "$fn" or return $txt;
	while(<TXTFH>) {
		m/\"$colname\"/i && do {
			m/\"Default\s+([^\"]+)\s*\"/;
$txt = "$1" if defined $1;
			dprint "<$db><$tbl><$colname><$txt>" if $txt ne "";
			last;
		}
	}
	close TXTFH;
	$txt;
}

sub getDefaultValueFromDB($$$$;) {
	my ($ttcserver, $db, $tbl, $col) = @_;
	# TODO
	return "";
}

sub getDefaultValue($$$;$$) {
	my ($db, $tbl, $colname, $type, $len) = @_;
	$type = "" unless defined($type);
	my $localselTxt = ($g_target eq "DIR")? (getDefaultValueFromMetadata($db, $tbl, $colname)) : (getDefaultValueFromDB($opt_ttcserver, $db, $tbl, $colname));
	if ($localselTxt eq "") {
#		dprint "WRN: <$db><$tbl> No default value for not null column $colname. Set one.\n";
		if (( $type eq "INTEGER" ) or ( $type eq "TINYINT" ) or ( $type eq "SMALLINT" ) or ( $type eq "INT" )){
$localselTxt = "0";
		} elsif (( $type eq "BINARY" ) or ( $type eq "VARBINARY" )) {
$localselTxt = "0x0";
		} elsif (( $type eq "CHAR" )or ( $type eq "VARCHAR" )) {
			my $length;
			$length = $len;
$localselTxt = "\'\'";
		} elsif (( $type eq "TIMESTAMP" )) {
			my $tm = [localtime];
			my $defaultTime = sprintf("%04d-%02d-%02d %02d:%02d:%02d", $tm->[5] + 1900, $tm->[4], $tm->[3], $tm->[2], $tm->[1], $tm->[0]);
$localselTxt = "\'$defaultTime\'";
		}
	}
	$localselTxt;
}

# get parameter like "3.2.9.0", returns "03.02.09.00", this format of version
# is used for directory name of a msc installation.
sub getLongReleaseNumber($;) {
	my ( @ver, $ver );

	;
	if ( not $_[0] =~ m/^(\d+).(\d+).(\d+).(\d+)$/ ) {
		print STDERR "ERROR: Bad release version, [$_[0]].\n";
		return "";
	}
	if ( length $1 == 1 ) {
		push @ver, "0" . $1;
	} else { push @ver, $1 }
	if ( length $2 == 1 ) {
		push @ver, "0" . $2;
	} else { push @ver, $2 }
	if ( length $3 == 1 ) {
		push @ver, "0" . $3;
	} else { push @ver, $3 }
	if ( length $4 == 1 ) {
		push @ver, "0" . $4;
	} else { push @ver, $4 }

	$ver = join ".", @ver;
	if ( length $ver != 11 ) {
		print STDERR "ERROR: Bad release version, [$_[0]].\n";
		$ver = "";
	}

	$ver;
}

# when the definition of a column changed, we have to decide whether its
# old and new type are compatible to know how to set the new value for
# the column. Two types are compatible if and only if they only differ in
# type length and the old definition has the shorter length.
sub isTypeCompatible( $$;$$ ) {
	my ( $ntype, $otype, $nlen, $olen ) = @_;

	if ( $ntype eq $otype ) {
		if ( !defined $nlen || defined $olen && $nlen >= $olen ) {
			return 1;
		}
		return 0;
	}

	if ( $otype eq "TINYINT" && ( $ntype eq "SMALLINT" || $ntype eq "INT" )
		|| $otype eq "SMALLINT" && $ntype eq "INT" ) {
		return 1;
	}
	0;
}

sub showChanges() {
	print STDOUT "TBI.\n"
}

# compare database files. Note that we need not get all differentiation data.
sub compareSchemas() {
	my ( $db, $tbl, $newtbl, $oldtbl, $col, $desc );

	# clear global data.
	%addonly = %removeonly = %recreate = ();
	@newcol = ();

	foreach $db (keys %{ $odbs }) {
		foreach $tbl (keys %{ $odbs->{$db} }) {
			if ( !exists($ndbs->{$db}{$tbl}) ) {
				$removeonly{$db}{$tbl} = 1;
				dprint "[$db][$tbl]:\t\tRemoved.";
				next;
			}

			my $processed = 0;
			$oldtbl = $odbs->{$db}{$tbl};
			$newtbl = $ndbs->{$db}{$tbl};
			$newtbl->{"__accessed"} = 1;

			if ( exists $newtbl->{"primaryKey"} ) {
				if ( exists $oldtbl->{"primaryKey"} ) {
					if ( $newtbl->{"primaryKey"} ne $oldtbl->{"primaryKey"}) {
						if ( ! $processed ) {
							$processed = 1;
							$recreate{$db}{$tbl} = 1;
						}
						dprint "[$db][$tbl]:\t\tPrimary key changed, need recreate.";
						if ( ! defined $opt_debug ) { next; }
					}
				} else {
					if ( ! $processed ) {
						$processed = 1;
						$recreate{$db}{$tbl} = 1;
					}
					dprint "[$db][$tbl]:\t\tPrimary key added, need recreate.";
					if ( ! defined $opt_debug ) { next; }
				}
			} elsif ( defined $oldtbl->{"primaryKey"} ) {
				if ( ! $processed ) {
					$processed = 1;
					$recreate{$db}{$tbl} = 1;
				}
				dprint "[$db][$tbl]:\t\tPrimary key removed, need recreate.";
				if ( ! defined $opt_debug ) { next; }
			}

			my ( %ocols, $tail, $colname, $coldesc );
			$tail = 1;	# flag of the column is in the tail.

			# build a hash table for fast test if a column exists in old table.
			for ( @{ $oldtbl->{"columns"} } ) {
				m/^(.+):(.+)$/;
				$ocols{$1} = $2;
			}

			my @localnewcols;
			for ( reverse @{ $newtbl->{"columns"} } ) {
				m/^(.+):(.+)$/;
				$colname = $1; $coldesc = $2;

				if ( defined $ocols{$colname} ) {
					$tail = 0;
					if ( !( $coldesc eq $ocols{$colname} ) ) {
						if ( ! $processed ) {
							$recreate{$db}{$tbl} = 1;
							$processed = 1;
						}
						dprint "[$db][$tbl]:\t\tColumn $1 definition changed from \"$ocols{$1}\" to \"$2\", need recreate.";
						if ( ! defined $opt_debug ) { last; }
					}
					delete $ocols{$1};
				} elsif ( ! $tail ) {
						if ( ! $processed ) {
							$recreate{$db}{$tbl} = 1;
							$processed = 1;
						}
						dprint "[$db][$tbl]:\t\tAdd column $1 before existing columns, need recreate.";
						if ( ! defined $opt_debug ) { last; }
				} elsif ( $coldesc =~ /NOT NULL$/ ) {
						if ( ! $processed ) {
							$recreate{$db}{$tbl} = 1;
							$processed = 1;
						}
						dprint "[$db][$tbl]:\t\tAdd column $colname that is not nullable, need recreate.";
						if ( ! defined $opt_debug ) { last; }
				} else { push @localnewcols, $1; }
			}
			if ( ! $processed || defined $opt_debug ) {
				for ( keys %ocols ) {	# some columns was deleted, need rectreate.
					if ( ! $processed ) {
						$recreate{$db}{$tbl} = 1;
						$processed = 1;
					}
					if ( ! defined $opt_debug ) { last; }
					dprint "[$db][$tbl]:\t\tRemove column $_.";
				}
			}
			if ( ! $processed || defined $opt_debug ) {	# Adding new columns has the lowest priority.
				for ( @localnewcols ) {
					if ( ! $processed ) {
						push @newcol, "$db:$tbl:$_";
					}
					dprint "[$db][$tbl]:\t\tAdd column $_.";
				}
			}
		} # end of foreach $tbl ...
		foreach $tbl (keys %{ $ndbs->{$db} }) {
			if ( exists $ndbs->{$db}{$tbl}{"__accessed"} ) { next }
			$addonly{$db}{$tbl} = 1;
			dprint "[$db][$tbl]:\t\tAdded.";
		}
	}
}

# create the script, write the basic template.
sub createFile($;) {

	open FH, ">" . $_[0] or die "Can't create or open file <$_>: $!";

# ------------START OF TEMPLATE ------------
print FH<<'EOF';
#!/bin/bash

#
# file: <filename>.sh
#
# Database migration script for in-service software upgrade
# from release <oldrel> to <newrel>.
#
# usage: <filename>.sh [OPTIONS]... PRIMARY_NODE_HOST_NAME [SECONDARY_NODE_HOSE_NAME]
#
#		-d <dir>    Specify the directory where custom scripts reside. User
#		              provided scripts will be executed at the very end of
#		              the migration process.
#		-h	        Display the usage and exit.
#		-e	        Executed on the remote server.
#		-s	        This is a SPLIT upgrading.
#		-r	        This is a Rolling upgrading.
#
# For SPLIT upgrade, this script shall be executed only on locked SIDE B card.
# And the host name of SIDE B card shall be used in place of PRIMARY_NODE_HOST_NAME.
# This script will not take operations on SIDE A cards in SPLIT upgrade mode.
#
# If SECONDARY_NODE_HOST_NAME is omitted, replication elements will not be created.
# This is suitable for lab configurations. In this situation, the script will not
# try to handle database replications at all.
#
# This script will migrate the Database for <cardtype> card ONLY.
#
# DON'T EDIT. THIS IS A MACHINE GENERATED FILE, Generated at <date>.
# TO ADD CUSTOM MIGRATION PROCEDURES, PUT YOUR SCRIPTS INTO THE CUSTOM SCIRPT
#   DIRECTORY AND EXCUTE WITH OPTION "-d".
#

CARD_TYPE=<cardtype>

showhelp=
mode=dynamic
opt_hasCustomScripts=0

usage()
{
	echo "usage: <filename>.sh [OPTIONS]"
	echo
	echo "  -d <dir>    Specify the directory where custom scripts reside. User"
	echo "                provided scripts will be executed at the very end of"
	echo "                the migration process."
	echo "  -h	Display the usage and exit."
	echo "	-e	Executed on the remote server."
	echo "	-s	Skip processing the TimesTen replications."
	echo
	echo "For rolling mode upgrade, use the -s option."
	echo
}

if [ -z "$1" ]; then
	usage
	exit 1
fi

while [ ! -z $1 ]; do
	case $1 in
	"-h")
		showhelp=1;;
	"-e")
	        shift
		mode=remote;;
	"-s")
		mode=skip;;
	"-d")
	    opt_hasCustomScripts=1

		if [ ! -d "$2" ]; then
		  usage
		  exit 1
		fi
		src_dir=$2

		shift;;
	*)
		echo "INFO: WRONG OR DUPLICATED ARGUMENTS, $1. IGNORED."
		;;
	esac
	shift
done

if [ $showhelp ]; then
	usage
	exit 0
fi

if [ $mode == "skip" ]; then
	TARGET_CARDS="$primary_node"
	if [ -z "$secondary_node" ]; then
		echo "ERROR: Missing secondary node name."
		exit 5
	fi
elif [ $mode == "remote" ]; then
	TARGET_CARDS=`hostname`
	if [ -z "$secondary_node" ]; then
		echo "ERROR: Missing secondary node name."
		exit 5
	fi
else
	TARGET_CARDS="$primary_node $secondary_node"
fi

. siteChk_profile

TMPDIR=/var/tmp/dbmig_<oldrel>_<newrel>
LOGFILE=$TMPDIR/log.$$
DEBUG=4

PKG_DIR=/space/spatialcd/<newrel>

SQLSYS="ttsys -v 1 -e "
SQLEMS="ttems -v 1 -e "
SQLMM="ttmm -v 1 -e "
SQLCALL="ttcall -v 1 -e "
SQLSS7="ttss7 -v 1 -e "
SQLSUB="ttsub -v 1 -e "
SQLDYN="ttdyn -v 1 -e "
SQLDDF="ttddf -v 1 -e "
SQLWL="ttwl -v 1 -e "

RSHCMD="rshCmd -q"
TTBULKCP=ttBulkCp

# Datastores whose replication shall be stopped while migration.
AFFECTED_DBS=<replication_dbs>
if [ ! -d "$TMPDIR" ]; then
	mkdir -p $TMPDIR
fi
if [ "$mode" == "remote" ]; then
	for ds in $AFFECTED_DBS
	do
		ttIsql -connstr dsn="${ds}Dir" -v 0 -e "quit"
	done
fi

dprint()
{
	if [ true ]; then
		echo $1
	fi
}

sanityCheck()
{
	echo ""
}

<altertable_def>
<addtable_defs>
<droptable_def>
<recreatetable_defs>

# teardown or setup replication on all nodes with <cardtype>
birep()
{
	if [ -z "$secondary_node" -o "$mode" == "remote" ]; then
		return 0
	fi

	local cmd
	if [ "$1" == "start" ]; then
		cmd="setupbirep"
	else
		cmd="teardownbirep"
	fi

	for db in $AFFECTED_DBS
	do
		# The teardownbirep will add DSN postfix (Dir | CS).
		$RSHCMD ". /.profile; $cmd $db" $TARGET_CARDS
	done
}

DB=
SQLCMD=

setSQLCmdForDb()
{
	if [ ! -z "$1" ]; then
		DB=$1
	fi
	case $DB in
		"SystemConfiguration" | "SYSTEMCONFIGURATION" ) SQLCMD=$SQLSYS;;
		"EmsData" | "EMSDATA" | "Performance" | "PERFORMANCE" )	SQLCMD=$SQLEMS;;
		"MMAppConfigData" | "MMAPPCONFIGDATA" ) SQLCMD=$SQLMM;;
		"SS7Configuration" | "SS7CONFIGURATION" ) SQLCMD=$SQLSS7;;
		"CallProcessing" | "CALLPROCESSING" ) SQLCMD=$SQLCALL;;
		"SubscriberData" | "SUBSCRIBERDATA" ) SQLCMD=$SQLSUB;;
		"DynamicDB" | "DYNAMICDB" ) SQLCMD=$SQLDYN;;
		"DDFData" | "DDFDATA" ) SQLCMD=$SQLDDF;;
		"WirelessData" | "WIRELESSDATA" ) SQLCMD=$SQLWL;;
		* )
			echo "Bad database name $1"
			exit 1;;
	esac
}

addTableToReplication()
{
	local tbl repType max newMax
	tbl=$1

	if [ -z $secondary_node ]; then
		return 0
	fi

	repType=`$SQLCMD "select REPLICATION_NAME from TTREP.REPLICATIONS;quit" | sed -e 's/<//g' -e 's/>//g' -e 's/ //g'`
	max=`$SQLCMD "select ELEMENT_NAME from TTREP.REPELEMENTS;quit" | sed -e 's/<//g' -e 's/>//g' -e 's/ //g' -e 's/(.)+_//g' | awk 'BEGIN {FS="_"} {print $NF}' | sort -n | tail -1`
	newMax=`expr $max + 1`

#	if [ $repType == "TWOREP" ]; then
		$RSHCMD ". /.profile; $SQLCMD \"ALTER REPLICATION TWOREP \
		 ADD  ELEMENT ${primary_node}_$newMax TABLE $tbl \
					  MASTER $DB ON ${primary_node} \
					  SUBSCRIBER $DB ON ${secondary_node} \
					 ;quit\"" $TARGET_CARDS

		$RSHCMD ". /.profile; $SQLCMD \"ALTER REPLICATION TWOREP   \
		  ADD ELEMENT ${secondary_node}_$newMax TABLE $tbl\
					  MASTER $DB ON ${secondary_node} \
					  SUBSCRIBER $DB ON ${primary_node} \
					 ;quit\"" $TARGET_CARDS
#	else
#
#	fi
}

dropRepElementForTable()
{
	local tbl repType elemList
	tbl=$1

	if [ -z $secondary_node ]; then
		return 0
	fi

	repType=`$SQLCMD "select REPLICATION_NAME from TTREP.REPLICATIONS;quit" | sed -e 's/<//g' -e 's/>//g' -e 's/ //g'`
	elemList=`$SQLCMD "select ELEMENT_NAME from TTREP.REPELEMENTS where DS_OBJ_NAME='$tbl';quit" | sed -e 's/<//g' -e 's/>//g' -e 's/ //g'`

	for elem in $elemList
	do
#		if [ $repType == "TWOREP" ]; then
			$RSHCMD ". /.profile; $SQLCMD \"alter replication TWOREP drop element $elem; quit\" " $TARGET_CARDS
#		else
#			$RSHCMD ". /.profile; $SQLCMD \"alter replication ${host1}REP drop element $elem; quit\"" $TARGET_CARDS
#			$RSHCMD ". /.profile; $SQLCMD \"alter replication ${host2}REP drop element $elem; quit\"" $TARGET_CARDS
#		fi
	done
}

callCustomScripts()
{
    if [ $opt_hasCustomScripts -eq 1 ]; then
        scripts=`find $src_dir -type f -name "*.sh"`
        for script in $scripts
        do
            /usr/bin/bash $script
        done
    fi
}

processReplications()
{
	birep stop

	# calling order is important.
	<call_recreate_tables>

	<call_add_table_funcs>

	callCustomScripts

	<call_drop_tables>

	birep start
}

main()
{
	sanityCheck

	<call_alter_table_funcs>
	sleep 3

	processReplications
}

main 2>&1 | tee $LOGFILE

EOF
# ------------END OF TEMPLATE ------------
close FH;
}

sub genAlterTableFunc() {
	my ( $text, @list );
	my ( $db, $tbl, @col, $desc );
	$db = $tbl = "";

	return "" if scalar @newcol == 0;

	@list = sort @newcol;	# Is this necessary? CHECK
	# add a dummy collumn at the end of list
	@newcol = reverse @newcol;
	push @newcol, "dummy:dummy:dummy";

$text = "
alterTables()
{
";
	for ( @newcol ) {
		m/^(.+):(.+):(.+)$/;
		if ( $db eq $1 and $tbl eq $2 ) {
			push @col, $3;
			next if $_ ne $newcol[$#newcol];
		}
		if ( $tbl ne "" ) {
			my $firstCol = 1;
			for ( @col ) {
				my ( $allcols, $i );
				$allcols = $ndbs->{$db}{$tbl}{"columns"};
				for ( $i = scalar(@$allcols) - 1; $i >= 0; --$i ) {
					if ( $allcols->[$i] =~ /^$_:(.+)$/ ) {
						$desc = $1;
						last;
					}
				}
		if ( $firstCol ) {
$text .= "\t\t";
		} else {
$text .= "
		,"
		}
$text .= "$_		$desc";
				$firstCol = 0;
			}
$text .= "
	);
";
			# set default value.
			for ( @col ) {
				my $col = $_;
				my $defval = getDefaultValue($db, $tbl, $col);
$text .= "	UPDATE SPATIAL.$tbl SET $col=$defval;
" if $defval ne "";
			}
			# override with values set in hint file. some inefficient.
			if ( exists $hints->{$db}{$tbl} ) {
				my @values = keys %{$hints->{$db}{$tbl}};
				for ( @values ) {
					if ( $hints->{$db}{$tbl}{$_} =~ m/^v:/ ) {
$text .= "	UPDATE SPATIAL.$tbl SET $_=$';
"
					}
				}
			}
$text .= "
	quit \"
	dprint \"DONE.\"
";
		}
		if ( $_ ne $newcol[$#newcol] ) {
			# new table
			$db = $1; $tbl = $2; @col = (); push @col, $3;
$text .= "
	dprint \"ALTERING TABLE $tbl...\"
	setSQLCmdForDb $db

\$SQLCMD \"
	ALTER TABLE SPATIAL.$tbl ADD (
";
		}
	}

$text .= "
}
";
	$text
}

sub parseHint() {
	return if not defined $opt_hint;

	my %hints;
	my $veryfied = 0;
	my ( $curDb, $curTbl, $oldTbl, $curCol, $oldCol, $defVal );

	for ( <HINTHDL> ) {
		chomp;

		next if /^\s*$/;	# skip empty lines
		next if /^\s*#/;	# skip comments

		if ( /\s*([\d.]+)\s*=>\s*([\d.]+)\s*(#.*)?$/ ) {
			if ( $veryfied or $1 ne $oldrel or $2 ne $newrel) {
				print STDOUT "Ignore the hint file for release numbers mismatching.\n";
				dprint "Source version: $oldrel";
				dprint "Target version: $newrel";
				dprint "Version specified in hint: $1=>$2";
				return;
			}
			$veryfied = 1;
			next;
		}

		if ( /^\[(.+)\]\s*(#.*)?$/i ) {	# db name
			$curDb = $1;
			$curDb =~ s/^\s+|\s+$//g;
			$curDb =~ tr/a-z/A-Z/;
			$curTbl = "";

			next;
		}
		next if $curDb eq "";

		if ( /^[^#]+:\s*(#.*)?$/i ) {	# table name, terminated with #
			tr/a-z/A-Z/;
			if ( /^[^#]+->/ ) { # format like old -> new
				/^([^\s]+)\s*->\s*(.+):\s*(#.*)?$/;
				$oldTbl = $1;
				$curTbl = $2;
				$curDb =~ s/^\s+|\s+$//g;
				$curTbl =~ s/^\s+|\s+$//g;
				$curDb =~ tr/a-z/A-Z/;
				$hints{$curDb}{$curTbl}{"_prevName"} = $oldTbl;
			} else {
				/^([^\s]+)\s*:\s*(#.*)?$/;
				$curTbl = $1;
				$curTbl =~ s/^\s+|\s+$//g;
				$oldTbl = "";
			}
			next;
		}
		next if $curTbl eq "";

		# now we can see columns.
		if ( /^([^\s]+)\s*->\s*([^\s]+)\s*(#.*)?$/ ) {
			$curCol = $2;
			$oldCol = $1;
			$curCol =~ s/^\s+|\s+$//g;
			$curCol	=~ tr/a-z/A-Z/;
			$oldCol =~ s/^\s+|\s+$//g;
			$oldCol	=~ tr/a-z/A-Z/;
			$hints{$curDb}{$curTbl}{$curCol} = "n:" . $oldCol;
		} elsif ( /^([^\s]+)\s*=\s*([^\s]+)\s*(#.*)?$/ ) {
			$curCol = $1;
			$defVal = $2;
			$curCol =~ s/^\s+|\s+$//g;
			$curCol	=~ tr/a-z/A-Z/;
			$hints{$curDb}{$curTbl}{$curCol} = "v:" . $defVal;
		}
	}

	\%hints;
}

sub genPrimaryKey($$;) {
	my ($tblDefs, $tbl) = @_;
	my $text = "
";
	my $pk = join ", ", split / /, $tblDefs->{"primaryKey"};
$text .= "		,PRIMARY KEY ($pk)" if $pk ne "";
}

sub genForeignKeys($$;) {
	my ($tblDefs, $tbl) = @_;
	my $fk;
	my $text = "
";

	if ( not exists $tblDefs->{"foreignKeys"} ) {
		return "";
	}
	for ( keys %{ $tblDefs->{"foreignKeys"} } ) {
		$fk = $tblDefs->{"foreignKeys"}{$_};
$text .= "		,FOREIGN KEY $fk
"
	}
	$text;
}

sub genIndexes($$;) {
	my ($indexes, $tbl) = @_;
	my $text = "
";
	for(keys %$indexes) {
$text .= "CREATE UNIQUE INDEX SPATIAL.$_ ON SPATIAL.$tbl ( ";
		my $cols = $indexes->{$_};
		for(keys %$cols) {
$text .= "$_,";
		}
		# remove last ","
		chop $text;
$text .= " );
"
	}
	$text
}

sub genCreateTableSql($$;) {
	my ( $tblDefs, $tbl ) = @_;
	my $text = "
	CREATE TABLE SPATIAL.$tbl (
\t\t";

	my $cols = $tblDefs->{"columns"};
	my $firstCol = 1;
	for ( @$cols ) {
		m/^(.+):(.+)$/;
$text .= "
		," if not $firstCol;
$text .= "$1		$2";
		$firstCol = 0;
	}
$text .= genPrimaryKey($tblDefs, $tbl);
$text .= genForeignKeys($tblDefs, $tbl);
$text .= "	);";
$text .= genIndexes($tblDefs->{"indexes"}, $tbl) if defined $tblDefs->{"indexes"};
	$text
}

sub getTempTblName($;) {
	my $temp = reverse($_[0]);
	if ( $temp =~ m/^[0-9_-]/ ) {
		$temp = "t" . $temp		# Table Name can't start with digit or _.
	}
	$temp
}

# Generate temporary table for $tbl.
sub genCreateTempTableSql($$;) {
	my ( $tblDefs, $tbl ) = @_;
	my $tblName = getTempTblName $tbl;
	my $text = "
	CREATE TABLE SPATIAL.$tblName (
\t\t";
	my $cols = $tblDefs->{"columns"};
	my $firstCol = 1;
	for ( @$cols ) {
		m/^(.+):(.+)$/;
$text .= "
		," if not $firstCol;
$text .= "$1		$2";
		$firstCol = 0;
	}
$text .= "
	);
	INSERT INTO SPATIAL.$tblName
	SELECT * FROM SPATIAL.$tbl;
";
}

# Forward declaration for recursive call. See below.
sub buildDependChain($$;);

sub buildDependChain($$;) {
	my ( $db, $tbl, $mode ) = @_;
	my %topNodes;
	my $scan = 1;
	my ( @stack, @depends );

	$topNodes{$tbl} = 1;
	while ( $scan ) {
		$scan = 0;
		for ( keys %topNodes ) {
			my $tn = $_;
			for ( keys %{ $odepends{$db}{$tbl}{"refTables"} } ) {
				if ( exists $recreate{$db}{$_} and not exists $topNodes{$_}) {
					$scan = 1;
					$topNodes{$_} = 1;
				}
			}
			delete $topNodes{$tn} if ( $scan == 1 );
		}
	}

	for ( keys %topNodes ) {
		next if ( exists $odepends{$db}{$_}{"_color"} );
		$odepends{$db}{$_}{"_color"} = 1;
		push @stack, $_;

		while ( $#stack >= 0 ) {
			$tbl = $stack[$#stack];
			for ( keys %{ $odepends{$db}{$tbl} } ) {
				next if ( exists $odepends{$db}{$_}{"_color"} || $_ eq "_color" || $_ eq "refTables" );
				$odepends{$db}{$_}{"_color"} = 1;
				push @stack, $_;
				last;	# Depth first searching.
			}
			if ( $tbl eq $stack[$#stack] ) {
				my $subdepends = buildDependChain($db, $tbl);
				push @depends, pop @stack;
				push @depends, @$subdepends if (scalar(@$subdepends) >= 0);
			}
		}
	}
	\@depends;
}

sub genMigrateFunc {
	my $text;
	my ( $chain, $db, $tbl, $otbl, $ncols, $ocols, %ocols );

	# process the change name tables.
	for ( keys %addonly ) {
		$db = $_;
		for ( keys %{ $addonly{$db} } ) {
			$tbl = $_;
			if ( !defined $hints or !exists $hints->{$db}{$tbl}{"_prevName"} ) {
				next;
			}
			delete $addonly{$db}{$tbl};
			if ( scalar keys %{ $addonly{$db} } == 0 ) { delete $addonly{$db} }
			$recreate{$db}{$tbl} = $hints->{$db}{$tbl}{_prevName};
		}
	}

	return "" if scalar keys %recreate == 0;

$text = "
migrate()
{
";
	# for each table need to be recreate
	for ( keys %recreate ) {
		$db = $_;
		if ( ! exists $repDbs{$_} ) { $repDbs{$_} = 1; }
		$tmpTbls{$db} = {};
$text .="
	setSQLCmdForDb $db
";
		for ( keys %{ $recreate{$db} } ) {
			$tbl = $_;

			next if ( exists $odepends{$db}{$tbl}{"_color"} and $odepends{$db}{$tbl}{"_color"} == 1);
			$chain = buildDependChain( $db, $tbl );

			for ( @$chain ) {
$text .= "
	echo \"MIGRATING TABLE $_ ...\"
";
				$odepends{$db}{$_}{"_color"} = 1;
				if ( !defined $recreate{$db}{$_} || $recreate{$db}{$_} eq "1" ) {
					# remove from @newcols, the table needs a recreate now, not just update.
					if ( !defined  $recreate{$db}{$_} ) {
						my $altTbl = $_;
						my @tempNewCols = @newcol;
						$#newcol = -1;
						for ( @tempNewCols ) {
							m/^(.+):(.+):(.+)$/;
							if ( $altTbl ne $2 ) {
								push @newcol, $_;
							}
						}
					}
					# build temp table.
$text .= "
\$RSHCMD \" . /.profile
\$SQLCMD \\\"
";
$text .= genCreateTempTableSql( $odbs->{$db}{$_}, $_ );
$text .= "
quit \\\" \" \$TARGET_CARDS
";
					# drop replication element, and table
					if ( $ndbs->{$db}{$tbl}{"NeedReplication"} ) {
$text .= "
	dropRepElementForTable $_
"
					}
$text .= "
\$RSHCMD \" . /.profile
\$SQLCMD \\\" DROP TABLE SPATIAL.$_; quit \\\"
\" \$TARGET_CARDS
";
					$tmpTbls{$db}{getTempTblName $_} = 1;
				} else {
					# delete renamed table from %removeonly if needed.
					if ( exists $removeonly{$db}{$recreate{$db}{$_}} ) {
						delete $removeonly{$db}{$recreate{$db}{$_}};
						if ( scalar keys %{ $removeonly{$db} } == 0 ) { delete $removeonly{$db} }
					}
					# drop replication element, and table
					if ( $odbs->{$db}{$recreate{$db}{$_}}{"NeedReplication"} ) {
$text .= "
	dropRepElementForTable $recreate{$db}{$_}
"
					}
					$tmpTbls{$db}{$recreate{$db}{$_}} = 1;
				}
			}

			# CHECK: the creation order of reverse of @chain may be invalid,
			#	when a ex-parent table now depends its ex-child table.
			for ( reverse @$chain ) {
				$tbl = $_;
				next if ( ! exists $ndbs->{$db}{$tbl} );
$text .= "
\$RSHCMD \" . /.profile
\$SQLCMD \\\"
";
$text .= genCreateTableSql($ndbs->{$db}{$tbl}, $tbl);
$text .= "
quit \\\" \" \$TARGET_CARDS
";
			if ( $ndbs->{$db}{$tbl}{"NeedReplication"} ) {
$text .= "
	addTableToReplication $tbl
";
			}
				# insert data.
				my ( $colname, $selname, $insTxt, $selTxt, $defVal );
$insTxt = "
\$RSHCMD \" . /.profile
\$SQLCMD \\\"
	INSERT INTO SPATIAL.$tbl (
";
$selTxt = "
	) SELECT
";
				$ncols = $ndbs->{$db}{$tbl}{"columns"};
				if ( !defined $recreate{$db}{$_} || $recreate{$db}{$tbl} eq "1" ) {
					$otbl = getTempTblName $tbl;
					$ocols = $odbs->{$db}{$tbl}{"columns"};
				} else {
					$otbl = $recreate{$db}{$tbl};
					$ocols = $odbs->{$db}{$otbl}{"columns"};
				}
				# build a hash table for fast test whether a column exists in old table.
				%ocols = ();
				for ( @$ocols ) {
					m/^(.+):(.+)/;
					$ocols{$1} = $2;
				}
				for ( @$ncols ) {
					m/^([^:]+):/;
					$colname = $1;
					if ( defined $hints and exists $hints->{$db}{$tbl}{$1} ) {
						$selname = $hints->{$db}{$tbl}{$1};
						$selname =~ m/^(.):(.+)$/;
						if ( $1 eq "n" ) {
							$selname = $2;
$selTxt .= "
		$selname,";
						} elsif ( $1 eq "v" ) {
							$defVal = $2;
$selTxt .= "
		$defVal,";
						}
					}
					elsif ( exists $ocols{$colname} ) {
						my ($oType,$oLength,$oNotNull,$nType,$nLength,$nNotNull);
										m/:([^\s]+)( \((.+)\))?( NOT NULL)?/;
										$nType = $1;
										$nLength = $3;
										$nNotNull = $4;

						$ocols{$colname} =~ m/:([^\s]+)( \((.+)\))?( NOT NULL)?/;
										$oType = $1;
										$oLength = $3;
										$oNotNull = $4;

						if ( defined $nNotNull ) {	# CHECK
							if ( isTypeCompatible ( $nType, $oType, $nLength, $oLength
													 && defined $oNotNull ) ){
$selTxt .= "
		$colname,"
							} else {
								$defVal = &getDefaultValue ($db, $tbl, $colname, $nType,$nLength);
$selTxt .= "
		$defVal,"
							}
						} else { # column can be null.
							if ( isTypeCompatible ( $nType, $oType, $nLength, $oLength ) ) {
$selTxt .= "
		$colname,"
							} else {
								$defVal = &getDefaultValue ($db, $tbl, $colname, $nType,$nLength);
$selTxt .= "
		$defVal,"
							}
						}
					} else { # for new columns.
						m/:([^\s]+)( \((.+)\))?( NOT NULL)?/;
#						if ( defined $4 ) {
							$defVal = &getDefaultValue ($db, $tbl, $colname, $1, $3);
$selTxt .= "
		$defVal,"
#						} else {
#$selTxt .= "
#		NULL,";
#						}
					}
$insTxt .= "
		$colname,";
				}
				# remove last comma
				chop ( $insTxt, $selTxt );
$selTxt .= "
	FROM SPATIAL.$otbl;

quit \\\" \" \$TARGET_CARDS
";
$text .= $insTxt . $selTxt;
				# delete it from %addonly if needed.
				if ( exists $addonly{$db}{$_} ) {
					delete $addonly{$db}{$_};
				}
			}
		}
	}
$text .= "
}
";
}

sub genDropTableFunc {
	my $text;

	return "" if scalar keys %removeonly == 0;

	my ( $db, $tbl );
$text = "
dropTables()
{
";
	for ( keys %removeonly ) {
		if ( ! exists $repDbs{$_} ) { $repDbs{$_} = 1; }
		$db = $_;
		# tables to be dropped only exist in OLD load.
$text .= "
	setSQLCmdForDb $_
";
		my @dropSeq = ();
		my @stack = ();
		# drop sub-tables first.
		for ( keys %{ $removeonly{$db} } ) {
			next if not $removeonly{$db}{$_};
			$tbl = $_;
			push @stack, $tbl;
			while ( $#stack >= 0 ) {
				$tbl = $stack[$#stack];
				for ( keys %{ $removeonly{$db} } ) {
					if ( exists $odepends{$db}{$tbl}{$_} and $removeonly{$db}{$_}) {
						push @stack, $_;
						last; # depth first
					}
				}
				if ( $tbl eq $stack[$#stack] ) {
					push @dropSeq, pop @stack;
					$removeonly{$db}{$tbl} = 0
				}
			}
		}

		for ( @dropSeq ) {
			$tbl = $_;

			# drop replication element
$text .= "
	dropRepElementForTable $tbl
";
$text .= "
\$RSHCMD \" . /.profile
\$SQLCMD \\\"
	DROP TABLE SPATIAL.$tbl;
quit \\\" \" \$TARGET_CARDS
	dprint \"DROPPED TABLE $tbl OF [$db].\"
";
		}
	}
	for ( keys %tmpTbls ) {
		$db = $_;
$text .= "
	setSQLCmdForDb $db;
";
		for ( keys %{$tmpTbls{$db}} ) {
$text .= "
\$RSHCMD \" . /.profile
\$SQLCMD \\\" DROP TABLE SPATIAL.$_; quit \\\"
\" \$TARGET_CARDS
";
		}
	}
$text .= "
}
";
}

sub getBulkFileName($$;) {
	my ($db, $tbl) = @_;
	$db = getDBCName $db;
	my $files = "";
	my @files;
	# there maybe more than one bulk file for one table. Get the latest one.
	# FIXME: for tables like EmsData::EmsEventData that there are more than one
	#	bulk files for it, must be handled separately.
	$files = qx(ls -t $opt_newdir/$db | egrep -i "^(insert)?$tbl(table)?.bulk\$");
	@files = split / /, $files;
	$files[0] = "" if not defined $files[0];
	chomp $files[0];
	return $files[0];
}

sub genCreateTableFunc {	# no hint tables.
	my ( $db, $tbl, $text, @funcs, $cols );

	return () if scalar keys %addonly == 0;

	for ( keys %addonly ) {
		$db = $_;
		if ( ! exists $repDbs{$_} ) { $repDbs{$_} = 1; }
		for ( keys %{ $addonly{$db} } ) {
			$tbl = $_;
$text = "
createNewTable_$db\_$tbl()
{
	dprint \"CREATING NEW TABLE $tbl...\"
	setSQLCmdForDb $db

\$RSHCMD \" . /.profile
\$SQLCMD \\\"
	CREATE TABLE SPATIAL.$tbl (
\t\t";
			$cols = $ndbs->{$db}{$tbl}{"columns"};
			my $firstCol = 1;
			for ( @$cols ) {
				m/^(.+):(.+)$/;
$text .= "
		," if not $firstCol;
$text .= "$1		$2";
				$firstCol = 0;
			}
$text .= genPrimaryKey($ndbs->{$db}{$tbl}, $tbl);
$text .= genForeignKeys($ndbs->{$db}{$tbl}, $tbl);
$text .= "
	);";
$text .= genIndexes($ndbs->{$db}{$tbl}{'indexes'}, $tbl) if defined $ndbs->{$db}{$tbl}{'indexes'};
$text .= "
quit \\\" \" \$TARGET_CARDS
	dprint \"DONE.\"
";
			if ( $ndbs->{$db}{$tbl}{"NeedReplication"} ) {
$text .= "
	addTableToReplication $tbl
";
			}
			# find defualt data to bulk in, if the target is database directory.
			if ($g_target eq "DIR") {
				my ( $bulk1, $bulk2 );
				my $dbcname = getDBCName $db;
				$bulk1 = getBulkFileName($db, $tbl);
				if ($bulk1 ne "") {
					$bulk1 = "\$PKG_DIR/Database/$dbcname/$bulk1";
$text .= "
	if [ -f $bulk1 ]; then
		\$TTBULKCP -i dsn=${db}DIR SPATIAL.$tbl $bulk1
		dprint \"BULKED IN DEFAULT DATA.\"
	fi
";
				}
				$bulk2 = $db;
				$bulk2 =~ tr/A-Z/a-z/;
				$bulk2 = "\$PKG_DIR/Database/Product/Atrium/$bulk2" . "_spatial." . $tbl . ".bulk";
				# FIXME: Only Atrium product needs data in /Product/Atrium.
				# Get product type?
$text .= "
	if [ -f $bulk2 ]; then
		\$TTBULKCP -i dsn=${db}DIR SPATIAL.$tbl $bulk2
		dprint \"BULKED IN DEFAULT DATA.\"
	fi
";
			}
			# TODO: Get default data from living DB too.
$text .= "
}
";

			push @funcs, $text;
		}
	}
	\@funcs;
}

sub gen {
	my ( $file, $fn, $alterFunc, $migrateFunc,
		$dropFunc, $addFuncs, $repFunc );

	return if scalar keys %addonly < 1 and scalar keys %removeonly < 1
			and $#newcol < 0 and scalar keys %recreate < 1;

	# TODO: Change the UI of scripts for CCM, DDM & DynamicDB. Only rolling mode
	#   is allowed.
	# TODO: Add roll back funciton to scripts for CCM, DDM & DynamicDB.

	# Clear temporary table cache.
	%tmpTbls = ();
	# Generation order is very important!
	$migrateFunc = genMigrateFunc();
	$alterFunc = genAlterTableFunc();
	$dropFunc = genDropTableFunc();
	$addFuncs = genCreateTableFunc();

	my ( $porel, $pnrel );
	$porel = $oldrel; $pnrel = $newrel;
	$porel =~ s/\.0$//; $pnrel =~ s/\.0$//;

	$fn = "dbmig_Rel" . join "_", split /\./, $porel;
	$fn .= "_to_Rel" . join "_", split /\./, $pnrel . "_$_";
	my $tmpfn = $fn . ".sh";
	createFile $fn . ".sh";
	$file = qx(cat $tmpfn);

	$file =~ s/<filename>/$fn/g;
	if ( $_ eq "DynamicDB" )	{
		$file =~ s/<cardtype>/SAM/g;
	}
	else {
		$file =~ s/<cardtype>/$_/g;
	}
	$file =~ s/<newrel>/$newrel/g;
	$file =~ s/<oldrel>/$oldrel/g;

	my $date = localtime;
	$file =~ s/<date>/$date/g;

	my $longRelNumber = getLongReleaseNumber $newrel;
	$file =~ s/<full_version>/$longRelNumber/g;

	my $funcname;
	$file =~ s/<altertable_def>/$alterFunc/g;
	$funcname = ( $alterFunc eq "" ) ? ("") : ("alterTables");
	$file =~ s/<call_alter_table_funcs>/$funcname/g;

	$file =~ s/<droptable_def>/$dropFunc/g;
	$funcname = ( $dropFunc eq "" ) ? ("") : ("dropTables");
	$file =~ s/<call_drop_tables>/$funcname/g;

	$file =~ s/<recreatetable_defs>/$migrateFunc/g;
	$funcname = ( $migrateFunc eq "" ) ? ("") : ("migrate");
	$file =~ s/<call_recreate_tables>/$funcname/g;

	my ( $repDbs );
	$repDbs = "\"" . ( join " ",( keys %repDbs ) ) . "\"";
	$file =~ s/<replication_dbs>/$repDbs/g;

	my ( $body, @head );
	$body = "";
	@head = ();
	for ( @$addFuncs ) {
		$body .= $_;
		/(\w+)\s*\(\)/;
		push @head, $1;
	}
	$file =~ s/<addtable_defs>/$body/g;
	$body = join "\n\n\t", @head;
	$file =~ s/<call_add_table_funcs>/\n\t$body/g;

	open FH, ">" . $fn . ".sh";
	print FH $file;
	close FH;
}

#------------Main------------#

# parse arguments
use Getopt::Long;

GetOptions( "help|h" => \$opt_help,
			"version|v" => \$opt_version,
			"debug|d" => \$opt_debug,
			"diff|f" => \$opt_diff,
			"o|olddir=s" => \$opt_olddir,
			"i|hint=s" => \$opt_hint,
			"b|db=s" => \$opt_ttcserver,
			"n|newdir=s" => \$opt_newdir);

if ( $opt_help ) {
	usage();
} elsif ( $opt_version ) {
	version();
}

if ( !defined($opt_newdir) && !defined($opt_ttcserver) ) {
	print STDERR "ERROR: Missing mandatory argument DATABASEDIR.\n";
	usage();
}

if ( defined($opt_olddir) && ! -d $opt_olddir ) {
	print STDERR "ERROR: $opt_olddir does not exist, or is not a directory.\n";
	usage();
}

if ( defined($opt_hint) ) {
	open HINTHDL, "<" . $opt_hint or die "Can't open $opt_hint: $!";
}

if ( defined($opt_newdir) ) {
	if ( ! -d $opt_newdir ) {
		print STDERR "ERROR: Bad parameter, [$opt_newdir] is not a directory.\n";
		usage();
	}

	if ( defined($opt_olddir) && $opt_newdir eq $opt_olddir ) {
		print STDERR "ERROR: Nothing to be done to same directory.\n";
		usage();
	}
	$g_target = "DIR";
	$newrel = getDBRelease($opt_newdir, "DIR");
} else {
	# TODO: Check target is ping-able and TimesTen is running.
	$g_target = "CS";
	$newrel = getDBRelease($opt_ttcserver, "CS");
}

if ( defined($opt_olddir) ) {
	$oldrel = getDBRelease($opt_olddir, "DIR");
} else {
	# TODO: check local TimesTen is running.
	$oldrel = getDBRelease("localhost", "CS");
}

if ( defined $opt_hint ) { $hints = parseHint(); }

for ('SAM', 'DynamicDB', 'DDM', 'CCM') {
	$odbs = ( defined($opt_olddir) ) ? ( getSchemaFromWS($opt_olddir) ) : ( getSchemaFromDB("localhost") );
	$ndbs = ($g_target eq "DIR") ? ( getSchemaFromWS($opt_newdir) ) : (getSchemaFromDB($opt_ttcserver));
	compareSchemas;
	showChanges if ( $opt_diff );
	%repDbs=();
	gen();
}
print "
The database migration scripts for upgrade from $oldrel to $newrel has been generated successfuly.\n
";

close HINTHDL if ( defined $opt_hint );

