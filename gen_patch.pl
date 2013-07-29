#!/usr/bin/perl
#The tool is a supplementary for the patch tool
#
#   April-10-2009    zhaowenlong    Created
#   April-20-2009    zhaowenlong    Finish the check_arguments and create_patch_list
#   April-21-2009    Liubo          Add the output
#   May-30-2009      zhaowenlong    optimize the code
#------------------------------------------------------------------------
use strict;

#Global variables
# opitions used by GetOpt:Long
my ($opt_help, $opt_debug,$opt_version,$opt_file,$opt_index,$opt_mount_dir,$opt_release,$opt_output_dir);

# caches
my ($tmp_index);

#Array @arr_range is used to store the index from user defined;
#Array @arr_metarange is used to store the index from metadata
#Hash %arr_record is used to store the information of required patch
my (@arr_range, @arr_metarange,%arr_record);

#List $ref_of_arr_meta is a reference,which is used to store the data in metadata
my $ref_of_arr_meta;

#
my (@mscPatches,@emsPatches,@msfPatches,@sqlPatches);
my ($module,$version,$checkSum,$destFile,$cardType,$c1,$c2);
#
my ($strCounter);

#log file
use File::Basename;
my $program=basename($0);
my $logfile="/var/tmp/$program.$$";

#Sub
sub usage() {

die <<EOS;
Usage:gen_patch.pl [OPTIONS] ...
          -h      Print the help,then exit
          -v      Print version number,then exit
          -d      Print debug information
          -f      Give the metadatafile
          -i      Give the index number, e.g. 1-14, 1-20,21
          -m      The usage defines the dir, if not, the default is ""
          -r      The SPATIAL release, e.g. 04.49.16.00
          -o      Give the output directory,or the current directory
Example:
----------------------
gen_patch.pl -f PATCH_WCS_449_SPARC.metadata -i 1-14,15 -r 04.49.16.00 -m /a -o /space/spatialcd/4.49.16.0/patch 
gen_patch.pl -f PATCH_WCS_449_SPARC.metadata -i 2,3,4 -o /space/spatialcd/4.49.16.0/patch 
gen_patch.pl -f PATCH_WCS_449_SPARC.metadata -i 13-6,7

EOS
}
sub version() {
die<<EOS
$program v0.1
A patchLoad.sh generator .

Copyright (C) 2009 Shanghai Bell, Inc.
EOS
}

sub dprint(@){
   if ( $opt_debug ) {print STDERR "[DEBUG]:@_\n";}
}

sub push2($$;) {
   my ($a,$b)=@_;
   
   if ($a >= $b) {
#using XOR(exclusive OR)
     $a= $a ^ $b; #get the middle value
     $b= $a ^ $b;
     $a= $a ^ $b;
   }
  my @data=();
  for ( my $i=$a; $i<=$b; $i++ ) { push @data, $i };
     return \@data;
}

sub make_array_of_range() {
}

sub make_array_of_metarange() {
}

sub verify_rang_in_metafile() {
}

sub sort_array_of_range() {
}
sub check_arguments() {
 if ( $opt_help ) {
     usage();
}
if ( $opt_version ) {
     version();
}

 if ( ! defined $opt_file || ! -f $opt_file) {
    print STDERR "[ERROR]:Missing the mandatory METADATA file or $opt_file isnot a file. \n";
    usage();
 }

 if ( ! defined $opt_index ) {
    print STDERR "[ERROR]:Missing the mandatory INDEX.\n";
    usage();
 } else {
    
    my @value=split /,/,$opt_index;
    for (@value) {
       dprint "INDEX:$_";
       if ($_ =~ /(\d+)-(\d+)/ ) {
         my ($left,$right)=($1,$2);
         
         $tmp_index=push2($left,$right);
       
       } elsif ($_ =~ /^(\d+)$/) {
         push @$tmp_index, $_;
       } else {
          print STDERR "[ERROR]:Wrong INDEX.\n";
          usage();
        }
    }
}
#   check the duplicated index
    my %seen=();
    my $item;
    foreach $item (@$tmp_index) {push @arr_range,$item unless $seen{$item}++;}

#TO DO:
#        The index must be ordinal;
         #make_array_of_range;
#        The range of defined index is the subset of the range of METADATA index
         #verify_rang_in_metafile;
#        Automatically discard the range not in metadata file
         #sort_array_of_range;
         
 if ( defined $opt_release){

 if ( $opt_release !~ /(\d{2}).(\d{2}).(\d{2}).(\d{2})/) {
     print STDERR "[ERROR]:Wrong SPATIAL Release.\n";
     usage();
 } else{
    #Check where it exists?
       if ( not -d "/Spatial/msc/$opt_release" ) {
           print STDERR "[ERROR]:Cannot find the defined Release.\n";
           usage();
         }
  }
    
} else{

 	  my $release=`ls -l /opt/Spatial/msc/ | grep active `;
 	  my @release=split /\s+/,$release;

    $opt_release=$release[$#release];

#     $opt_release="04.04.49.00";
 }

 if ( defined $opt_mount_dir && ! -d $opt_mount_dir ) {
     print STDERR "[ERROR]:Cannot find the Mount Point\n";
     usage();
 } elsif (-d $opt_mount_dir){
 }else {
    $opt_mount_dir="";
 }

 if ( defined $opt_output_dir && ! -d $opt_output_dir  ) {
       print STDERR "[ERROR]:Cannot find the output Point\n";
       usage();
 } elsif ( -d $opt_output_dir) {
       #fix the bug
       my @dir=split /\//, $opt_output_dir;
       $opt_output_dir=join "/",splice @dir,0,$#dir+1;
       
 	}else {
    $opt_output_dir=`pwd`;
    chomp $opt_output_dir;
 }
 
 if( -e "$opt_output_dir/patchLoad.sh"){
   print STDERR "$opt_output_dir/patchLoad.sh has existed, Pls check again.\n";
	 exit;
}
    
}

sub read_metadatafile($){
    my $file=$_[0];
    dprint "METADATA FILE:$file";
    
    use Fcntl;
    sysopen(METADATA,$file,O_RDONLY) or die "Cann't open $file for reading.$!";
    my @line=();
    my $t_id=0,
    my $t_patchname="";
    
    while (<METADATA>) {
       my @tmp=();
       dprint "Data:$_";
       chomp;
       if( $_ =~ /^##/ ) {next;}
       if ( $_ =~ /^#SS7/) {next;}
       if ( $_ =~ /^#PMC/) {next;}
       if ($_ =~ /^#MSCVERINFO/) {next;}
       if ($_ =~ /^\s*$/) {next;}
       if ($_ =~ /^#PATCHINFO/) {
          @line=split /\s+/,$_;
          $t_id=$line[1];
          $t_patchname=$line[3];
          next; 
       }
       
       if ( $t_id == 0 || $t_patchname eq "" ) {
          print STDERR "[ERROR]:Invalid format in $opt_file,line $.\n";
          exit;
       }
       
       @tmp=split /\s+/,$_;
       
       #Have to record the patchname and id
       push @tmp,$t_patchname;
       push @tmp,$t_id;  

       #$p_module,$p_version,$p_checksum,$p_destfile,$p_cardtype,$p_execute,$p_directory,$t_patchname,$t_id
       push @$ref_of_arr_meta,[ @tmp ];
       
    }
    close METADATA;
    
    #print the array of array
    if ( $opt_debug ){
       my ($i,$j);
       for $i (0 .. $#{@$ref_of_arr_meta}) {
          my $row=@$ref_of_arr_meta[$i];
          
          for $j (0 .. $#{$row} ) {
             print "element $i $j is $row->[$j]\n";
         }
      }
   }
}
sub get_patchname_from_index($;){
       my $index=$_[0];
       dprint "Patch Name:$index";
       
       for my $i (0 .. $#{@$ref_of_arr_meta}) {

          if ( $ref_of_arr_meta->[$i][8] == $index ) { #t_id
             return $ref_of_arr_meta->[$i][7];         #t_patchname
            }
      }
       return "unknown";
}

sub get_modules_from_index($;){
       my $index=$_[0];
       my @list=();

       for my $i (0 .. $#{@$ref_of_arr_meta}) {	

          if ( $ref_of_arr_meta->[$i][8] == $index ) { 
             
             #@list is used to record the $t_id which meet the index in @$ref_of_arr_meta 
             push @list,$i; 
            }
       }
       
       \@list;
}

sub create_patch_list() {
   
   %arr_record=();
   for(sort @arr_range){ #2-15
       my $item=$_;
      
       my $patchname=get_patchname_from_index($item);
       my $ilist=get_modules_from_index($item);
    
       print "#------($item)------$patchname--------------------\n";
       
       my $done=0;
       for(@$ilist) { 
          my $rownum=$_;
          
          my $t_module=$ref_of_arr_meta->[$rownum][0];
          my $t_checksum=$ref_of_arr_meta->[$rownum][2];
          my $t_destfile=$ref_of_arr_meta->[$rownum][3];
          my $t_catdtype=$ref_of_arr_meta->[$rownum][4];
          
          $arr_record{$t_module}=["$t_destfile","$t_catdtype","$t_checksum"];
          
          if ( exists $arr_record{$t_module} ) {
             # replace old one by new one
             
             #$arr_record{$t_module}=["$t_destfile","$t_catdtype","$t_checksum"];
             print "Patch $t_module is replcaced by $patchname: $t_module\n" ;
             next;
          } else {
             #we donot meet any duplicate module,so we add the module
             #TO DO:It's better keep the order
             
             #Hash of Array,%arr_record,
             
             #$arr_record{$t_module}=[ "$t_destfile","$t_catdtype","$t_checksum" ];
             
             print "Registering Patch $patchname:$t_module\n";
            
          }
       }
    
   }
   
    if ($opt_debug) {
      #print the hash of array
       for my $module (keys %arr_record) {
          print "Module:$module\n";
          
          for my $i ( 0 .. $#{$arr_record{$module}} ) {
             print "Info:$arr_record{$module}[$i]\n";
          }
          print "\n";
       }
    }
   
}


sub genPatchStr
{ 
   for my $module (keys %arr_record) {
         
       my ($destFile,$cardType,$checkSum)=($arr_record{$module}[0],$arr_record{$module}[1],$arr_record{$module}[2]); 
       
#       if ( $opt_debug ) {
         dprint "Module:$module\n";
         dprint "DestFile:$destFile\n";
         dprint "CardType:$cardType\n";
         dprint "CheckSum:$checkSum\n";
#       }
        my  @mscStr=();
        my  @emsStr=();
        #For different cases, we have to deal with it
        my @cards;
        #0. don't deal with MGW patches, CardType->NA
        if ("$destFile" eq "NA" && "$cardType" eq "NA") {
           next;
         } elsif ( "$destFile" eq "NA" && "$cardType" ne "NA") {
             #1. patchGui cannot deal with the patches , Destfile->NA
             my @patches=qw( patchutil.tcl patchtool patchgui rshCmd siteChk_incl.sh);
             
             foreach (@patches) {
                if ($module =~ $_ ) {
                push @cards, "all";
                }
             if ( $_ =~ /^patch/) {
             	  $destFile = "/opt/Spatial/msc/active/installation";
             	} else {
             		$destFile = "/opt/Spatial/msc/active/tools";
             		
             		}
             }
         } else {
                @cards = split (/,/,$cardType);
                $destFile =~ s/\/$module//;   #/Spatial/msc/active/patch/SMS
               
        }

	
	if(defined $opt_mount_dir && $opt_mount_dir ne "")
	{
	  if ($destFile =~ /^\/opt/  ) {
	    $destFile =~ s/active/$opt_release/; 
            foreach(@cards)
	    {
	       if ($module !~ /.jar$/)
	       {
			push(@mscStr,"$module\@$_\@$opt_mount_dir$destFile");
		}else{
			push(@emsStr,"$module\@$_\@$opt_mount_dir$destFile");
		}
	    }
            
         } elsif ( $destFile =~ /^\/Spatial/ )
	{
		foreach(@cards)
	       {
		  if ($module !~ /.jar$/)
		 {
		  push(@mscStr,"$module\@$_");
		  
		  }else
		 {
		  push(@emsStr,"$module\@$_");
		  }
		}
	}
	else
	 {
            	print  "INFO:Need Not deal with $module.\n";
	 }
	}else{
	    if ($destFile =~ /^\/opt/)
	    {
	       $destFile =~ s/active/$opt_release/;
		#print($destFile);
		foreach(@cards)
		{
		  if ($module !~ /.jar$/)
		  {
		   push(@mscStr,"$module\@$_\@$destFile");
		  
		  }else
		  {
		   push(@emsStr,"$module\@$_\@$destFile");
					
		  }
	       }
		
	    }elsif($destFile =~ /^\/Spatial/)
	    {
		foreach(@cards)
	       {
		  if ($module !~ /.jar$/)
		 {
		  push(@mscStr,"$module\@$_");
		  
		  }else
		 {
		  push(@emsStr,"$module\@$_");
		  }
		}
		
	    }else
	    {
	       print "INFO:Need NOT deal with $module\n";
	    }
	}
	#print(@emsStr);
    if (@mscStr)
   {
	push(@mscPatches,@mscStr);
	$strCounter++;
	if ($strCounter%2 == 0)
	{
	 push(@mscPatches,"\n");	
	}
   }
   if(@emsStr)
    {
      push(@emsPatches,@emsStr);
   }
   }
}


sub outFile
{
my $template='#!/bin/bash
#
# /space/spatialcd/<release_number>/patch/patchLoad.sh <flag> [<card_Type]>
#  flag      = verify    - verify this script
#              no        - do not do SQL scripts
#              yes       - do SQL scripts
#              downgrade - only do downgrade actions
#              register  - register patches
#  card_Type = type of card being patched (sim, ddm, ccm, sam, all)
#
# Make no changes except in the following four clearly marked sections!
# Make no changes except in the following four clearly marked sections!
#
# To verify your changes, ensure that the file is located in directory
#   /space/spatialcd/<target_release>/patch
# and execute the file with a command-line argument of "verify" like:
#   /space/spatialcd/<target_release>/patch/patchLoad.sh verify
#
#------------------------------
# CHANGE 1: If any patches are required for the MSC, put them
#  within doublequotes with a target card specifier. Separate each filename
#  with blanks; for example:
# mscPatches="BsPm@all SgwIsup@ccm"
#  Card specifiers must be one of: sim, ddm, ccm, sam, all
#
#  Add any MSC-related filenames between the doublequotes in the next line:

mscPatches="<mscPatches>"
#------------------------------

#------------------------------
# CHANGE 2: If any patches are required for the EMS, put them
#  within doublequotes with a target card specifier. Separate each filename
#  with blanks; for example:
# emsPatches="emsmain.jar@sam"
#  Card specifiers normally will be: sam
#
#  Add any EMS-related filenames between the doublequotes in the next line:
emsPatches="<emsPatches>"
#------------------------------

#------------------------------
# CHANGE 3: If any patches are required for the MSF, put them
#  within doublequotes with a target card specifier. Separate each filename
#  with blanks; for example:
# msfPatches="ramCMM_02ss_80_01.bin@sam"
#  Card specifiers normally will be: sam
#
#  Add any MSF-related filenames between the doublequotes in the next line:
msfPatches="<msfPatches>"
#------------------------------

#------------------------------
# CHANGE 4: If SQL files are being used to make extra changes, then
#   they should apply to a specific DSN and they should be contained
#   in a file. Place the DSN name and the filename into the following
#   variable in this format: filename$DSN
#   For example:
# sqlPatches="EmsData.sql@EmsData ddf_changes.sql@DDFData"
#
#  Add any SQL filenames between the doublequotes in the next line:
sqlPatches="<sqlPatches>"
#------------------------------

#==========================================================================
#
# D o   n o t   c h a n g e   a n y   l i n e s   b e l o w   h e r e ! !
#
#==========================================================================

# $Header: /homes/CVS_REPOSITORY/WSS100/srcbase/installation/patchLoad.sh,v 2.1 2005/08/03 20:32:05 builder Exp $
#

# Source common header file
#
. upgrade_incl.sh

# ---------------
# Defines
#

ACTION_PATCH=0
ACTION_VERIFY=1
ACTION_REGISTER=2

# ---------------
# Functions
#

# ===================
# Make sure that the original file is saved to the proper location
#   before overwriting the file. The file will be passed to the patch
#   utility at "register" time so it is available for unpatching.
#
# Arg 1 = directory path for file to be saved
# Arg 2 = filename

function saveOriginalFile {

local dirPath filename samIP remFile

dirPath="$1"
filename="$2"

# Only copy the original file if it has not already been copied
#
#samIP=`mount | grep /space/spatialcd | \
#       sed \'s@/space/spatialcd on \(.*\):/space/spatialcd.*$@\1@\'`

#if [ -n "$samIP" ]; then
# The target SAM is a remote card, not ourself
#
#  remFile=${workDir}/orig/${filename}
#  if [ "`rsh $samIP ls $remFile 2>&1`" != "$remFile" ]; then
#    echo " -${prefix}- Info: Saving original remote file..."
#    rcp -p ${dirPath}/${filename} ${samIP}:${workDir}/orig/
#  fi
#else
# Local card
#
  dirArr=(`echo ${dirPath} | sed \'s/\/ /g\'`)

  dir_index=`let ${#dirArr[@]} - 1`

   if [ ! -f ${workDir}/${filename} ]; then
          echo " -${prefix}- Info: Saving original local file to ${workDir}/orig/${dir_index[$dir_index]} ."
          
          test -d ${workDir}/orig || mkdir -p ${workDir}/orig/${dir_index[$dir_index]}
          cp -p ${dirPath}/${filename} ${workDir}/orig/${dir_index[$dir_index]}
         fi
         
#fi

}

# ===================
# Process the patch files based on the action
#
# Arg 1 = type of patch
# Arg 2 = action
# Arg 3 = patch list

function processPatches {

local type patchList action typeStr patchDir fileEle fileArr
local file forType altDestDir msfDir

type="$1"
action="$2"
patchList="$3"

# set the default destination directory (may be overridden)
#
case $type in
  msc ) typeStr="MSC"; patchDir="/Spatial/msc/${formalRelNum}/patch" ;;
  ems ) typeStr="EMS"; patchDir="/Spatial/ems/${formalRelNum}/patch" ;;
  msf ) typeStr="MSF"; patchDir="/Spatial/msf/[0-9]*/${formalRelNum}/BIN" ;;
  *   ) echo " -${prefix}- Error: Invalid type param: $type"
        exit 1 ;;
esac

if [ -n "$patchList" ]; then
  for fileEle in $patchList
  do
    fileArr=(`echo $fileEle | sed \'s/@/ /g\'`)
    file=${fileArr[0]}
    forType=${fileArr[1]}
    altDestDir=${fileArr[2]}
    trueTgtDir=""

    if [ "$forType" != "$currentTgt" -a "$forType" != "all" -a \
         "${action}" -eq $ACTION_PATCH ]; then
      # Skip patching this card if the file is not for this card or "all"
      #
      continue
    fi

    if [ "${action}" -eq $ACTION_PATCH ]; then
      # Apply the patch, but must save the original file if it is being
      #   overwritten
      #
      if [ "$type" != "msf" ]; then
        # May be patching to a non-default directory
        #
        if [ -n "$altDestDir" ]; then
          trueTgtDir=${altDestDir}
        else
          trueTgtDir=${patchDir}
        fi

        # Save an original file so it can be unpatched if necessary
        #
        if [ -f "$trueTgtDir/$file" ]; then
          saveOriginalFile "$trueTgtDir" "$file"
        fi

        echo " -${prefix}- Info: On $currentTgt for $forType: \
$file -> $trueTgtDir"
        cp -p ${file} ${trueTgtDir}
      else
        # Copy to all MSF instances
        #
        for msfDir in `ls -d ${patchDir}`; do
          # Save an original file so it can be unpatched if necessary
          #   (only do this for the first MSF\'s instance)
          #
          if [ -z "$trueTgtDir" ]; then
            trueTgtDir=$msfDir
            if [ -f "$trueTgtDir/$file" ]; then
              saveOriginalFile "$trueTgtDir" "$file"
            fi
          fi

          echo " -${prefix}- Info: On $currentTgt for $forType: \
$file -> $msfDir"
          cp -p ${file} $msfDir/${file}
        done
      fi
    elif [ "${action}" -eq $ACTION_VERIFY ]; then
      # verify the patch
      #
      if [ ! -f ${file} ]; then
        echo " -${prefix}- Error: ${typeStr} file ${file} is not found"
        let errFlag+=1
      elif [ ! -x ${file} -a ${type} == "msc" ]; then
        # If there is no alt dir or the file in the alt dir is executable
        #   then consider this an error. Worst case is user can make the
        #   patch file executable.
        #
        if [ -z "${altDestDir}" -o -x "${altDestDir}/${file}" ]; then
          echo " -${prefix}- Warning: ${typeStr} file ${file} is not executable"
          let errFlag+=1
        fi
      fi

      if [ -z "$forType" ]; then
        echo " -${prefix}- Error: Card type specifier is missing from ${file}"
        let errFlag+=1
      else
        case $forType in
         sim | ipm | ddm | ccm | sam | all ) ;;
         * ) echo " -${prefix}- Error: Invalid card type specifier for ${file}: ${forType}"
             let errFlag+=1 ;;
        esac
      fi
    else
      # generate register info (make empty file to mark that we\'ve done this)
      #
      if [ ! -f ${workDir}/${file} ]; then
        trueTgtDir=${patchDir}
        origFile=""
        if [ -n "$altDestDir" ]; then
          trueTgtDir=${altDestDir}
        fi
        if [ -f ${workDir}/orig/${file} ]; then
          origFile=${workDir}/orig/${file}
        fi
        echo "${trueTgtDir},${file},${forType},${origFile}" >> \
          ${workDir}/patchInfo
        touch ${workDir}/${file}
      fi
    fi
  done
fi
}

# # # # # # # # #
# Main script
#

usage="Usage: /space/spatialcd/<release_number>/patch/patchLoad.sh <flag> [<card_Type]>
  flag      = verify   - verify this script
              no       - do not do SQL scripts
              yes      - do SQL scripts
              register - register patches
  card_Type = type of card being patched (sim, ddm, ccm, sam, all)
"

if [ $# -lt 1 ]; then
  echo "Too few arguments."
  echo "$usage"
  exit 1
fi

flag="$1"
downgrading=""
errFlag=0

if [ "${flag}" == "no" -o "${flag}" == "yes" -o "${flag}" == "downgrade" ]; then
  if [ "${flag}" != "downgrade" ]; then
    prefix="PatchLoad"
  else
    downgrading="downgrading"
    prefix="Downgrade"
  fi

  action=$ACTION_PATCH
  if [ -z "$2" ]; then
    echo "Flag \'${flag}\' requires that a target cardtype type be given"
    echo "$usage"
    exit 1
  else
    currentTgt=` echo "$2" | tr \'[:upper:]\' \'[:lower:]\'`
    case $currentTgt in
     sim | ipm | ddm | ccm | sam | all ) ;;
     * ) echo "Invalid target card type : $2"
      echo "$usage"
      exit 1 ;;
    esac
  fi

elif [ "${flag}" == "verify" ]; then
  prefix="Verify"
  action=$ACTION_VERIFY

  if [ "$2" == "downgrade" ]; then
    downgrading="downgrading"
  elif [ -n "$2" ]; then
    echo "Invalid second argument of $2"
    echo "$usage"
    exit 1
  fi

elif [ "${flag}" == "register" ]; then
  prefix="Register"
  action=$ACTION_REGISTER
else
  echo " -${prefix}- Invalid flag argument: $1"
  echo "$usage"
  exit 1
fi

# cd into the directory holding this script and remember the path
#
cd `dirname "$0"`
targdir=`pwd`

# Get the release number
#
releaseNum=`echo $targdir | sed \'s@/space/spatialcd/\([0-9.]*\)/patch@\1@\'`
if [ "$releaseNum" == "$targdir" ]; then
  echo "Location of this script is not correct. It must be in:
  /space/spatialcd/<release_number>/patch
The script being executed is in:
  $targdir

$usage"
  exit 1
fi

chkRelease $releaseNum
formalRelNum=$RET_RELEASE

# If verifying patches, then create the working directory
#
workDir=/var/tmp/patchLoad_${formalRelNum}
#if [ "${action}" -eq $ACTION_VERIFY ]; then
#  # Must be on the primary SAM (really, the /space/spatialcd home card)
#  #
#  if [ -n "`mount | grep /space/spatialcd`" ]; then
#    echo "Register action must take place on the /space/spatialcd home card"
#    exit 1
#  fi
#  test -d ${workDir} || mkdir -p ${workDir}/orig
#fi
test -d ${workDir} || mkdir -p ${workDir}/orig

# Possibly remove any prior patches unless patches are already present or we
#   are in downgrade mode
#
curPatches=`ls /Spatial/*/${formalRelNum}/patch/* 2> /dev/null; \
            ls /Spatial/msf/[0-9]*/${formalRelNum}/BIN/* 2> /dev/null`
if [ \( "${action}" -eq $ACTION_PATCH -o \
        "${action}" -eq $ACTION_VERIFY \) -a \
     -n "$curPatches" -a \
     -z "$downgrading" ]; then
  if [ "${action}" -eq $ACTION_PATCH ]; then
    if [ -n "$mscPatches" -a \
         -f /Spatial/msc/${formalRelNum}/patch/UPGRADE_OVERWRITE ]; then
      \rm /Spatial/msc/${formalRelNum}/patch/* > /dev/null 2>&1
    fi
    if [ -n "$emsPatches" -a \
         -f /Spatial/ems/${formalRelNum}/patch/UPGRADE_OVERWRITE ]; then
      \rm /Spatial/ems/${formalRelNum}/patch/* > /dev/null 2>&1
    fi
    if [ -n "$msfPatches" -a \
         -f /Spatial/msf/[0-9]*/${formalRelNum}/BIN/UPGRADE_OVERWRITE ]; then
      \rm /Spatial/msf/[0-9]*/${formalRelNum}/BIN/* > /dev/null 2>&1
    fi
  else
    echo " -${prefix}- Error: Patches are already present; not re-applying.
If you wish to re-apply patches, you must do one of the following:
 1) invoke the split script with the -p option for downgrade (recommended);
 2) empty the patch directories at:
   /Spatial/msc/${formalRelNum}/patch/
   /Spatial/ems/${formalRelNum}/patch/
   /Spatial/msf/[0-9]*/${formalRelNum}/BIN/
or
 3) make a file named \'UPGRADE_OVERWRITE\' in the patch directories.
These patches are present:
$curPatches
"
    exit 1
  fi
fi

# Do not apply patches in downgrade mode since the old release may have
#   already been patched with more up-to-date files than we know about here
#
if [ -z "${downgrading}" ]; then

  # Apply MSC patches
  #
  processPatches "msc" "$action" "$mscPatches"

  # Apply EMS patches
  #
  processPatches "ems" "$action" "$emsPatches"

  # Apply MSF patches
  #
  processPatches "msf" "$action" "$msfPatches"

else
  # Skip patching
  #
  echo " -${prefix}- Info: ${flag} flag was passed in so skipping patches."
fi

#---------------------------------------------
# Spatial special-case items   S T A R T
# - Spatial personnel may direct that extra steps be added here.
#   Do so only with explicit direction from Spatial!

if [ "${action}" -eq $ACTION_PATCH ]; then
 :
fi

# Spatial special-case items   E N D
#---------------------------------------------

cd ${targdir}

# Apply SQL patches
#
if [ "${flag}" != "no" ]; then
  CP_update="ConfigParams_auto_updates.sql@SystemConfiguration"

  # If in downgrade mode, then only process the ConfigParams update file
  #
  if [ -n "${downgrading}" ]; then
    sqlPatches=""
  fi

  # For each SQL pair in the list, apply it if the DSN exists on this card
  #
  for pair in $CP_update $sqlPatches; do
    pair_array=(`echo $pair | sed \'s/@/ /\'`)
    file=${pair_array[0]}
    dsn=${pair_array[1]}
    dsnFile="/Spatial/db/${dsn}.ds0"

    if [ ! -f "${file}" ]; then
      echo " -${prefix}- Error: SQL file ${file} not present."
      let errFlag+=1
    fi

    # Verify the DSN name (all DSNs are created on the SAM)
    #
    if [ ${action} -eq $ACTION_VERIFY -a ! -f ${dsnFile} ]; then
      echo " -${prefix}- Error: DSN name, ${dsn}, not correct."
    fi

    if [ ${action} -ne $ACTION_PATCH ]; then
      continue
    fi

    if [ -f ${dsnFile} ]; then
      echo " -${prefix}- Info: Applying ${file} to ${dsn}"
      $TTISQL -connStr "dsn=${dsn}Dir;uid=spatial;" -v 1 -f ${file}
    else
      echo " -${prefix}- Info: ${dsn} for patch of ${file} not on this card."
    fi
  done
fi

if [ $errFlag -ne 0 ]; then
  echo " -${prefix}- ${errFlag} error(s) were detected. Correct and reverify."
elif [ ${action} -eq $ACTION_REGISTER ]; then
  if [ -f ${workDir}/patchInfo ]; then
    # Register patches
    #
    # swpatch.tcl -patch username module version desc cardtype
    #                    status srcfile destdir
    #
    for lineEle in `cat ${workDir}/patchInfo`; do
      lineArray=(`echo $lineEle | sed \'s/,/ /g\'`)
      destDir=${lineArray[0]}
      module=${lineArray[1]}
      forType=${lineArray[2]}
      origFile=${lineArray[3]}

      outStr=`swpatch.tcl -patch upgrade ${module} 1 \
         "Part of ${releaseNum} upgrade" \
         "${forType}" "ACTIVE" "${origFile}" ${destDir} 2>&1`
      retStat=$?
      logStr "Registered $module for $forType: $outStr"
      if [ $retStat -ne 0 ]; then
        echo " -${prefix}- Error: Error registering patch for module ${module}"
      fi
    done
  else
    echo " -${prefix}- Info: No patches to register"
  fi
fi

# exit
exit $errFlag
';
	
#print $code;
   $template =~ s/<mscPatches>/@mscPatches/;
   $template =~ s/<emsPatches>/@emsPatches/;
   $template =~ s/<msfPatches>/@msfPatches/;
   $template =~ s/<sqlPatches>/@sqlPatches/;

   open(OUTFILE,">$opt_output_dir/patchLoad.sh") || die "open $opt_output_dir/patchLoad.sh failed";
   print OUTFILE $template;
   close(OUTFILE);
   printf "-----------------------------------------\n";
   print "The Output File is in $opt_output_dir/patchLoad.sh \n";
		
}

#Main
#-----------------------------------------------------------------
print "Running $program ...\n";
open(STDOUT ,"| tee $logfile" ) or die "[ERROR]:Cannot open TEE to $logfile";

my $date=`date '+%m/%d/%y'`;
chomp $date;
printf "\nRunning Date:%s\n",$date;
printf "-----------------------------------------\n";

use Getopt::Long;
GetOptions( "help|h" =>\$opt_help,
            "version|v" =>\$opt_version,
            "debug|d" =>\$opt_debug,
            "f|file=s" =>\$opt_file,
            "i|index=s" =>\$opt_index,
            "m|mount:s" =>\$opt_mount_dir,
            "r|release:s" =>\$opt_release,
            "o|output:s" =>\$opt_output_dir);

check_arguments;
#Get the required patch info

read_metadatafile $opt_file;

create_patch_list;
#Generate patchLoad.sh based on the above info

genPatchStr;
outFile;

# 
print "Writing log to $logfile \n";
close STDOUT;
