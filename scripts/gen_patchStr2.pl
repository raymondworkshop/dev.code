#!/usr/bin/perl -w
#The tool is supplementary for the patch tool
#
#   April-17-2009
#------------------------------------------------------------------------
#Global variables
use strict;

sub usage() {
die<<EOS
gen_patchLoad.pl [OPTIONS] ...
    -h      Print the help,then exit
    -v      Print version number,then exit
    -d      Print debug information
    -f      Give the metadatafile
    -i      Give the index number, e.g. 1-14, 1-20,21
    -m      The usage defines the dir, if not, the default is /
    -r      The SPATIAL release, e.g. 04.49.00.00
    -o      Give the output directory,or the current directory
Example:
----------------------
gen_patchLoad.pl -f PATCH_WCS_449_SPARC.metadata -i 1-14,15 -r 04.49.00.00 -m /a -o /export/home/
gen_patchLoad.pl -f PATCH_WCS_449_SPARC.metadata -i 5,6,7 -o /export/home/
gen_patchLoad.pl -f PATCH_WCS_449_SPARC.metadata -i 13-6,7 

EOS
}

my ($opt_help,$opt_version,$opt_debug,$opt_file,$opt_index,$opt_mount_dir,$opt_release,$opt_output_dir);
my ($module,$version,$checkSum,$destFile,$cardType,$c1,$c2);
my (@mscStr,@emsStr);
my (@mscPatches,@emsPatches,@msfPatches,@sqlPatches);
my ($strCounter);

#$opt_mount_dir="/a";
$opt_release="04.49.00.00";
$opt_output_dir="/bliu006/GenPatch";


my $logFile = "/tmp/genPatchlog.$$";
open(GENLOG,">$logFile")|| die("open $logFile failed");	
print GENLOG "Start auto generate file patchLoad.sh \n";

open(STUFF,"testData2")||die "Can't open myfile:$!";	

$strCounter=0;
while (<STUFF>)
{
	if (! /^\s*$/)
	{
		chomp();	
		($module,$version,$checkSum,$destFile,$cardType,$c1,$c2)=split(/ +/, $_);
		print GENLOG "INFO:module:$module,version:$version,checkSum:$checkSum,deskFile:$destFile,cardType:$cardType \n";
		&genPatchStr();
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
close(STUFF);
print GENLOG "INFO:mscPatches=@mscPatches\n";
print GENLOG "INFO:emsPatches=@emsPatches\n";

&outFile();

close(GENLOG);

sub genPatchStr
{
	@mscStr=();
	@emsStr=();
	my @cards = split (/,/,$cardType); 
#	print ("$module,$version,$checkSum,$destFile,$cardType,$c1,$c2\n");
	$destFile =~ s/\/$module//;
	if(defined $opt_mount_dir)
	{
		if ($destFile !~ /^\/var/)
		{
			$destFile =~ s/active/$opt_release/;
			#print("$destFile\n");
			foreach(@cards)
			{
				if ($module !~ /.jar$/)
				{
					push(@mscStr,"$module\@$_\@$opt_mount_dir$destFile");
					print GENLOG "INFO:Generate new mscPatchStr:@mscStr\n";
				}
				else
				{
					push(@emsStr,"$module\@$_\@$opt_mount_dir$destFile");
					print GENLOG "INFO:Generate new emsPatchStr:@emsStr\n";
				}
			}
		}
		else
		{
			#need to fix
			print GENLOG "INFO:Need to fix destFile:$destFile start with /var\n";
		}
	}
	else
	{
		if ($destFile =~ /^\/opt/)
		{
			$destFile =~ s/active/$opt_release/;
			#print($destFile);
			foreach(@cards)
			{
				if ($module !~ /.jar$/)
				{
					push(@mscStr,"$module\@$_\@$destFile");
					print GENLOG "INFO:Generate new mscPatchStr:@mscStr\n";
					#print("$patchStr\n");
				}
				else
				{
					push(@emsStr,"$module\@$_\@$destFile");
					print GENLOG "INFO:Generate new emsPatchStr:@emsStr\n";
				}
			}
			#print("@mscStr\n\n");
		}
		elsif($destFile =~ /^\/Spatial/)
		{
			foreach(@cards)
			{
				if ($module !~ /.jar$/)
				{
					#print("$module\n");
					push(@mscStr,"$module\@$_");
					print GENLOG "INFO:Generate new mscPatchStr:@mscStr\n";
					#print("@mscStr\n");
				}
				else
				{
					push(@emsStr,"$module\@$_");
					print GENLOG "INFO:Generate new emsPatchStr:@emsStr\n";
					#print("@emsStr\n");
				}
			}
			#print("@mscStr\n\n");
		}
		else
		{
			print GENLOG "INFO:Need to fix destFile:$destFile start not with /opt and /Spatial\n";
		}
	}
	#print(@emsStr);
}
sub outFile
{
	my ($template);
	$template='#!/bin/bash
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

@mscPatches="<mscPatches>"
#------------------------------

#------------------------------
# CHANGE 2: If any patches are required for the EMS, put them
#  within doublequotes with a target card specifier. Separate each filename
#  with blanks; for example:
# emsPatches="emsmain.jar@sam"
#  Card specifiers normally will be: sam
#
#  Add any EMS-related filenames between the doublequotes in the next line:
@emsPatches="<emsPatches>"
#------------------------------

#------------------------------
# CHANGE 3: If any patches are required for the MSF, put them
#  within doublequotes with a target card specifier. Separate each filename
#  with blanks; for example:
# msfPatches="ramCMM_02ss_80_01.bin@sam"
#  Card specifiers normally will be: sam
#
#  Add any MSF-related filenames between the doublequotes in the next line:
@msfPatches="<msfPatches>"
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
@sqlPatches="<sqlPatches>"
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

dirPath=$1
filename=$2

# Only copy the original file if it has not already been copied
#
samIP=`mount | grep /space/spatialcd | \
       sed \'s@/space/spatialcd on \(.*\):/space/spatialcd.*$@\1@\'`
if [ -n "$samIP" ]; then
  # The target SAM is a remote card, not ourself
  #
  remFile=${workDir}/orig/${filename}
  if [ "`rsh $samIP ls $remFile 2>&1`" != "$remFile" ]; then
    echo " -${prefix}- Info: Saving original remote file..."
    rcp -p ${dirPath}/${filename} ${samIP}:${workDir}/orig/
  fi
else
  # Local card
  #
  if [ ! -f ${workDir}/${filename} ]; then
    echo " -${prefix}- Info: Saving original local file..."
    cp -p ${dirPath}/${filename} ${workDir}/orig/
  fi
fi
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
	if(-e "$opt_output_dir/patchLoad.sh")
	{
		print STDERR ("$opt_output_dir/patchLoad.sh exists.\n");
		print GENLOG "INFO:$opt_output_dir/patchLoad.sh exists,new patchLoad.sh failed to generate\n ";
	}
	else
	{
		#print("@mscPatches");
		#print(@emsPatches);
		$template =~ s/<mscPatches>/@mscPatches/;
		$template =~ s/<emsPatches>/@emsPatches/;
		$template =~ s/<msfPatches>/@msfPatches/;
		$template =~ s/<sqlPatches>/@sqlPatches/;

		print GENLOG "INFO:Start output file patchLoad.sh \n ";

		open(OUTFILE,">$opt_output_dir/patchLoad.sh") || die "open $opt_output_dir/patchLoad.sh failed";
		print OUTFILE $template;
		close(OUTFILE);
		 
		print GENLOG "INFO:File patchLoad.sh succeed to generate in $opt_output_dir \n ";
	}
		
}
