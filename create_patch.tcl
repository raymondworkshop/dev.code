#!/opt/ActiveTcl/bin/tclsh
#update the code and add the function: check module using check with metadata by zhaowenlong

package require Expect

set g(usage) "Usage :
create_patch.tcl -m <metadatafile> -d <srcdirpath> -r <range> -o <outdir>
          where 
                <range> = e.g. 1-14,16-23
                               54-51,46 (metadata index numbers)
                <outdir> = Name of the output directory where all patches should be copied.
                           It will create script named \"<outdir>.tcl\" and by executing
                           that script, directory <outdir> and file <outdir>.tar will be created.
                <srcdirpath> = patch directory name(comma separated if more than one),
                               without any white space in between
                               e.g. /proj/wss100/build/PATCH_2317_3_SP4/2.3.37.0.patch
                Type 'ls -d /proj/wss100/build/*/*.patch' command to see the possible patch directories
               
The tools also can be used to CHECK the module with the metadata
create_patch.tcl -m <metadatafile> -r <range> -e /export/home/zhaowl/patch/test7
"
# CheckArguments
proc CheckArguments {} {
  global g
  if {$g(argc) < 1 } {
    puts "Wrong number of arguments"
    puts "$g(usage)"
    exit
  }
    Get_option_create
    Validate_option_create
}

# Get_option_create
proc Get_option_create {} {
  global g
#  if { $g(argc) <= 5 } {
#    puts "$g(usage)"
#    exit
#  }
  for { set i 0 } { $i < $g(argc) } { incr i } {
    set arr($i) [lindex $g(argv) $i]
  }
  
  set g(metadata_option) 0
  set g(tmp_range) 0
  set g(outfile) 0
  set g(base_dirlist) {}
  set g(patchfile) {}
  
  for { set i 0 } { $i < $g(argc) } { incr i } {
    set tmp $arr($i)
    switch  -- $tmp {
		{-m} {
				if ![info exists arr([expr $i+1])] {
				  puts "Please provide metadata filepath"
				  puts "$g(usage)"
				  exit
				}
				incr i
				set g(metadatafile) $arr($i)
				set g(metadata_option) 1
			  }
	  {-r}    {
                if ![info exists arr([expr $i+1])] {
                  puts "Please provide range"
                  puts "$g(usage)"
                  exit
                }
                incr i
                set g(tmp_range) $arr($i)
              }
      {-o}    {
                if ![info exists arr([expr $i+1])] {
                  puts "Please provide outdir"
                  puts "$g(usage)"
                  exit
                }
                incr i
                set g(outfile) $arr($i)
              }
      {-d}    {
                if ![info exists arr([expr $i+1])] {
                  puts "Please provide srcdirpath"
                  puts "$g(usage)"
                  exit
                }
                incr i								
		set tmpdirnames $arr($i)
		set tmpdirlist [split $arr($i) ,]
                
		foreach tmpdir $tmpdirlist {
		    # Remove / from the end of dirname
		      regsub -- {([/]*)$} $tmpdir "" tmpdir
			lappend g(base_dirlist) $tmpdir
		}
              }
     {-e}     {
               if ![info exists arr([expr $i+1])] {
                 puts "Please provide patchdir"
                 puts "$g(usage)"
                 exit
                }
                 incr i
                 
                 set g(patchfile) $arr($i)
      }
     
     default  {
                puts "Invalid argument : '$tmp'"
                puts "$g(usage)"
                exit
              }
    }
  }

  if {[llength $g(base_dirlist)] == 0} {
#    puts "Patch Sourcepath not specified"
#    puts "$g(usage)"
#    exit
  } else {
    VerifyBaseDirList $g(base_dirlist)
  }
  if {"$g(metadata_option)"=="0"} {
    puts "Metadata file not specified"
    puts "$g(usage)"
    exit
  }
  if {"$g(tmp_range)"=="0"} {
    puts "range not specified"
    puts "$g(usage)"
    exit
  }
  
if !{[ string equal "$g(base_dirlist)" "" ]} {
   	  if {[ string equal "$g(patchfile)" "" ]} {
  if {"$g(outfile)"=="0"} {
    puts "Outdir not specified"
    puts "$g(usage)"
    exit
  }
}
}

# Validate_option_create
proc Validate_option_create {} {
  global g arr_range arr_metarange
  
  if ![file isfile $g(metadatafile)] {
    puts "'$g(metadatafile)' is not a valid metadata file"
    exit
  }
  ReadMetadataFile
  MakeArrayOfRange $g(tmp_range) arr_range
  MakeArrayOfMetaRange arr_metarange
  set notlist [VerifyRangeInMetadataFile arr_range arr_metarange]
  if {[llength $notlist] > 0} {
    puts "Following index nums specified in range were not found in Metadata file"
    puts "[lsort -integer $notlist]"
    exit 1
  }

  SortArrayOfRange arr_range arr_metarange

  #puts "Printing Patch Directories"
  #PrintArrayOfRange arr_dir
if !{[ string equal "$g(base_dirlist)" "" ]} {
   	  if {[ string equal "$g(patchfile)" "" ]} {
  set myoutfile ${g(outfile)}.tcl
  if [catch {set g(outfd) [open $myoutfile w+]} result] {
    puts "Error while creating '$myoutfile' ..."
    puts "$result"
    exit
  }
  puts $g(outfd) "#!/opt/ActiveTcl/bin/tclsh"
  puts $g(outfd) "\n# patchlist $g(argv)"
}
}
}
# VerifyBaseDirList
proc VerifyBaseDirList { dirlist } {
  foreach i $dirlist {
    if ![file isdirectory $i] {
      puts "'$i' is not a valid directory name"
      exit
    }
  }
}

# ReadMetadataFile
proc ReadMetadataFile {} {
	global g arr_meta

	if [ catch { set meta_fd [open $g(metadatafile) r] } result ] {
		puts "Could not open metadata file '$g(metadatafile)' "
		puts "$result"
    exit
	}

	if [ catch { read $meta_fd } result ] {
		puts "Could not read metadata file $g(metadatafile)"
		puts "$result"
		exit
	}

	set t_id "unknown"
  set t_patchname "unknown"
  set counter 0

  foreach line [split $result \n] {
		if [ regexp -- {^##} $line ] { continue }
    if ![string compare $line ""] {continue}
    if [regexp -- {^#SS7 } $line] {
      set g(ss7_list) {}
      foreach i [split [lindex $line 1] ,] {lappend g(ss7_list) $i}
      continue
    }
    if [regexp -- {^#PMC } $line] {
      set g(pmc_list) {}
      foreach i [split [lindex $line 1] ,] {lappend g(pmc_list) $i}
      continue
    }
    if [regexp -- {^#MSCVERINFO } $line] {
      set g(mscverinfo_list) {}
      foreach i [split [lindex $line 1] ,] {lappend g(mscverinfo_list) $i}
      continue
    }
    if [regexp -- {^#PATCHINFO } $line] {
      set t_id [lindex $line 1]
      set t_patchname [lindex $line end]
      continue
    }
    if {"$t_id"=="unknown" || "$t_patchname"=="unknown"} {
      puts "Invalid format in '$g(metadatafile)', line :\n'$line'"
      exit
    }
    set t_list {0 1 2 3 4 5 6 7 8}
    set t_list [lreplace $t_list $g(meta_index) $g(meta_index) $t_id]
    set t_list [lreplace $t_list $g(meta_patchname_index) $g(meta_patchname_index) $t_patchname]
    set t_list [lreplace $t_list $g(meta_module_index) $g(meta_module_index) [lindex $line 0]]; # module
    set t_list [lreplace $t_list $g(meta_version_index) $g(meta_version_index) [lindex $line 1]]; # version
    set t_list [lreplace $t_list $g(meta_cksum_index) $g(meta_cksum_index) [lindex $line 2]]; # cksum

    set arr_meta($counter) $t_list
    incr counter   
	}
}

# MakeArrayOfRange
proc MakeArrayOfRange { rlist arr_name } {
  upvar $arr_name t_array
  catch {unset t_array}
  set counter 0
  set t_list [split $rlist ,]
  foreach i $t_list {
    if [regexp -- {-} $i] {
      # When range is specified with '-' 
      set x_list [split $i -]
      set xlength [llength $x_list]
      if { $xlength != 2 } {
        puts "Invalid range : $i"
        exit
      }
      set one [string trimleft [lindex $x_list 0] 0]
      set two [string trimleft [lindex $x_list 1] 0]
      if {"$one"=="" } {
        puts "Invalid range (missing element before '-') $i"
        exit
      }
      if {"$two"=="" } {
        puts "Invalid range (missing element after '-') $i"
        exit
      }
      if {$one <= $two} {
        for {set c $one} {$c <= $two} {incr c} {
          set t_array($counter) $c
          incr counter
        }
      } else {
      	for {set c $one} {$c >= $two} {set c [expr $c - 1]} {    
          set t_array($counter) $c
          incr counter
      	}
      }
    } else {
      # When range is simply a number (no '-')
    	if {"$i"==""} {
        puts "Invalid range : (blank)"
        exit
    	}
      set i [string trimleft $i 0]      
      set t_array($counter) $i
      incr counter
    }
  }

  # check for duplicate entries in array
  for {set i 0} { $i < [array size t_array] } { incr i } {
    set t1 $t_array($i)
    for {set j [expr $i+1]} { $j < [array size t_array] } { incr j } {
      set t2 $t_array($j)
      if {"$t1"=="$t2"} {
        puts "Duplicate/Overlapping Entry found in specified range : $t2"
        exit
      }
    }
  }
}

# SortArrayOfRange
# sorts arr_range as per entries ordered in arr_metarange
# it automatically discards range not in metadata file
proc SortArrayOfRange {arr_range_name arr_metarange_name} {
  upvar $arr_range_name t_array
  upvar $arr_metarange_name t_array2

  set rlist {}
  set sortedlist {}
  foreach i [array names t_array] {
    lappend rlist $t_array($i)
  }
  catch {unset t_array}
  set counter 0
  foreach i [lsort -integer [array names t_array2]] {
    if {[lsearch -exact $rlist $t_array2($i)] >= 0} {
      set t_array($counter) $t_array2($i)
      lappend sortedlist $t_array2($i)
      incr counter
    }
  }
  # you can use this sortedlist, however arr_range_name is already updated by this function
  return $sortedlist
}

# MakeArrayOfMetaRange
# This rlist contains the order of patch indexes based on metadata file,
# so it is the master order list
proc MakeArrayOfMetaRange {arr_metarange_name} {
  global g arr_meta
  upvar $arr_metarange_name t_array
  set rlist {}
  foreach i [lsort -integer [array names arr_meta]] {
    set r [lindex $arr_meta($i) $g(meta_index)]
    if {[lsearch -exact $rlist $r] < 0} {lappend rlist $r}
  }
  if {[llength $rlist] == 0} {
    puts "No patch information found in Metadata file"
    exit
  }
  catch {unset t_array}
  set c 0
  # Note: If you will sort rlist, ordering will be as per index numbers in metadata file.
  # If you will NOT sort rlist, ordering will be as per actual order in which all patches
  # are listed in metadata file (and not based on index numbers)
  foreach i [lsort -integer $rlist] {
    set t_array($c) $i
    incr c
  }
}

# VerifyRangeInMetadataFile
proc VerifyRangeInMetadataFile {arr_range_name arr_metarange_name} {
  upvar $arr_range_name t_array
  upvar $arr_metarange_name t_array2
  set metalist {}
  foreach i [array names t_array2] {lappend metalist $t_array2($i)}
  set notlist {}
  foreach i [array names t_array] {
    if {[lsearch -exact $metalist $t_array($i)] < 0} {lappend notlist $t_array($i)}
  }
  return $notlist
}

# CreatePatchList
proc CreatePatchList {} {
  global g arr_range arr_meta arr_record

  # Pass through each patch range in metadata file
  set xc 0
  foreach item [lsort -integer [array names arr_range]] {
    set i $arr_range($item)
    set patchname [GetPatchNameFromIndex $i]
    set ilist [GetModulesFromIndex $i]
    
    if !{[ string equal "$g(base_dirlist)" "" ]} {
   	  if {[ string equal "$g(patchfile)" "" ]} {
    puts $g(outfd) "# ------($i)--------- $patchname -----------------"
	  }
    }
    puts "# ------($i)--------- $patchname -----------------"

    set counter 1
    foreach j $ilist {
      incr xc
      set line $arr_meta($j)
      set t_id ${patchname},$counter
      incr counter
      
      set t_cksum [lindex $line $g(meta_cksum_index)]
      set t_module [lindex $line $g(meta_module_index)]
      set t_version [lindex $line $g(meta_version_index)]
      if ![string compare $t_version "NA"] { set t_version "0" }

      # Always use BuildRecord function to build a new record. It will help maintaining code in future
      #set t_record [ BuildRecord $t_id $t_module $t_srcfile $t_destfile  $t_ctlist  $t_version $t_cksum $t_cponly $t_exeonly $g(register_4_apply_status)]
      set t_record [list $t_id $t_module $t_cksum]

      set done 0
      foreach k [lsort -command sort_arr_record [array names arr_record]] {
        set k_print [lindex [split $k ,] 0]
        if ![string compare "$t_id" "$k"] {
          puts "Record '$k_print' already exists : $t_module"
          puts $g(outfd) "# Record '$k_print' already exists : $t_module"
          set done 1
          break
        }
        set record [lindex $arr_record($k) 0]
        set module [lindex $record 1]
        if ![string compare "$module" "$t_module"] {
          unset arr_record($k)
          set arr_record($t_id) [list $t_record $xc]
          puts "Patch '$k_print' is replaced by '$patchname' : $t_module"
          puts $g(outfd) "# Patch '$k_print' is replaced by '$patchname' : $t_module"
          set done 1
          break
        }
      }
      if {$done == 0} {
        # We didn't encounter any duplicate module, so we shall add this record
        set arr_record($t_id) [list $t_record $xc]
        puts "Registering Patch '$patchname' : $t_module"
        puts $g(outfd) "# Registering Patch '$patchname' : $t_module"
      }
    }
  }

   
   #get the tar file
   if !{[ string equal "$g(base_dirlist)" ""  ]} {
   	  if {[ string equal "$g(patchfile)"  "" ]} {
       GetTarFile
      }
   }
   
   if !{[ string equal "$g(patchfile)" "" ]} {
   	  if {[ string equal "$g(base_dirlist)" "" ]} {
    
       checkPatchFile $g(patchfile)
      }
    }
}
proc checkPatchFile {dir} {
  
   global g arr_record
   set list {}
   set flist {}
   set clist {}
   set ulist {}
   
   if ![catch {set list [glob $dir/*]}] {
   
   foreach j $list {
     set ftype [file type $j]
     if ![string compare $ftype "file"] {
     	# set x [lindex [split $j /] end ]
         lappend flist $j

     }
     if ![string compare $ftype "directory"] {
        puts "$j is a directory, skip"
      }
   }
   

  foreach i [lsort -command sort_arr_record [array names arr_record]] {
      
      
      set t_record [lindex $arr_record($i) 0]
      set t_id [lindex $t_record 0]
      set t_dir [lindex [split $t_id ,] 0]
      set t_module [lindex $t_record 1]
      set t_cksum [lindex $t_record 2]
      #puts "The Module is:$t_module"
      
      set done 0
      foreach f $flist {
         set x [lindex [split $f /] end ]
         #puts "x:$x"
         if {[string equal "$t_module" "$x"]} {
         	 
           if !{[catch {eval exec /usr/bin/cksum $f} result]} {
           	  
           	   #puts "result:$result"
               set g_cksum [lindex $result 0]     
               if { "$t_cksum" == "$g_cksum" } {
                # puts "The cksum of $x is the same"
                 set done 1
                 break
               } else {
                 lappend clist $t_module
                 #puts "The Cksum of the $x is different between the $dir and the metadata"
                 set done 1
                 break
                }
             }
         }
       }
          
       if { $done == 0 } {
         #cannot find the module in arr_record
          
          lappend ulist $t_module
          puts "Cannot find the $t_module during the index rang "
        }
   }
   
   if !{[string equal "$clist" "" ]} {
   puts "The following files cksum don't match with metadatafile , please check................." 
   foreach j $clist {
     
     puts "$j"
    }
   }
   if !{[string equal "$ulist" "" ]} {
   puts "The following file don't exsit , please check........................................."
   foreach i $ulist {
    
    puts "$i"
   }
  }
   }
}

#GetTarFile
proc GetTarFile {} {
   global g arr_record
   
    puts $g(outfd) ""
  set xc 0
  puts "\nStarting final step"
  set tmpdir $g(outfile)
  puts "tmpdir=$tmpdir"
  if ![file isdirectory $tmpdir] {
    #if [catch {file mkdir $tmpdir} result] {
    #  puts "Error while creating directory $tmpdir"
    #  puts "$result"
    #  exit
    #}
  }
   
    foreach i [lsort -command sort_arr_record [array names arr_record]] {
    set t_record [lindex $arr_record($i) 0]
    set t_id [lindex $t_record 0]
    set t_dir [lindex [split $t_id ,] 0]
    set t_module [lindex $t_record 1]
    #Donot deal with DB patch
    #if {[ string match {PATCH_[DM]*-DB.sh} $t_module ]} {
    	#puts "t_module:$t_module"
   # 	 break;
   # }
  # Now we are done, we have to save the data in output file
 
    set cpFrom [GetSrcFile $t_module $t_dir]
    set cpTo $tmpdir
    #set cpTo [GetCpTo "$tmpdir" "$cpFrom" "$t_dir"]
    #set xdir [file dirname $cpTo]
    puts $g(outfd) "file mkdir $cpTo"
    puts $g(outfd) "file copy $cpFrom $cpTo"
    puts $g(outfd) ""
    incr xc
  }
  set cmd "exec /usr/bin/tar -cof ${tmpdir}.tar $tmpdir"
  puts $g(outfd) "$cmd"
  close $g(outfd)
  exec /usr/bin/chmod 777 ${g(outfile)}.tcl
  
}

# GetPatchNameFromIndex
proc GetPatchNameFromIndex {i} {
  global g arr_meta
  foreach item [array names arr_meta] {
    set line $arr_meta($item)
    set r [lindex $line $g(meta_index)]
    set p [lindex $line $g(meta_patchname_index)]
    if {"$r"=="$i"} {return $p}
  }
  return "unknown"
}

# GetModulesFromIndex
# returns a list of 'array names' of arr_meta for selected index number of patchname
proc GetModulesFromIndex {i} {
  global g arr_meta
  set ilist {}
  foreach item [lsort -integer [array names arr_meta]] {
    set line $arr_meta($item)
    set r [lindex $line $g(meta_index)]
    if {"$r"=="$i"} {lappend ilist $item}
  }
  return $ilist
}

# sort_arr_record
# used by CreatePatchList
proc sort_arr_record {i j} {
  global arr_record
  set one [lindex $arr_record($i) 1]
  set two [lindex $arr_record($j) 1]
  if {$one < $two} {
    return -1
  } elseif {$one == $two} {
    return 0
  } else {
  	return 1
  }
}

# GetFiles

proc GetFiles { currdir } {
  
  set mylist {}
  set dirlist {}
  if ![catch {set flist [glob $currdir/*]}] {
    foreach i $flist {
      set ftype [file type $i]
      if ![string compare $ftype "file"] {
        lappend mylist $i 
      } elseif ![string compare $ftype "directory"] {
        lappend dirlist $i
      }
    }
    set mylist [lsort $mylist]
    set dirlist [lsort $dirlist]
    foreach j $dirlist { 
      set tmplist [GetFiles $j] 
      foreach k $tmplist { 
        if ![string compare $k ""] { 
        } else { 
          lappend mylist $k 
        } 
      } 
    } 
  }
  return $mylist
}

# GetDir
# requires patchname and returns its fullpath, exits if can not find that dir.
proc GetDir {d} {
  global g arr_dir arr_files
  if [info exists arr_dir($d)] {
    return $arr_dir($d)
  }
  foreach t_dir $g(base_dirlist) {
    set tmp ${t_dir}/$d
    if [file isdirectory $tmp] {
      set arr_dir($d) $tmp
      set arr_files($d) [GetFiles $tmp]
      return $tmp
    }
  }
  puts "Could not find patch directory '$d' under any directory \
    specified in Patch Sourcepath"
  exit
}

# GetSrcFile
# gets filelist of dir and returns t_module filepath from it
proc GetSrcFile {t_module d} {
  global arr_dir arr_files
  if ![info exists arr_files($d)] {
    GetDir $d
  }
  foreach fname $arr_files($d) {
    set t_name [file tail $fname]
    if ![string compare $t_name $t_module] {
      return $fname
    }
  }
  puts "Could not find module file '$t_module' under directory '$arr_dir($d)'"
  exit
}

# GetCpTo
# e.g. 
# c = ./tmp1091
# a = "/opt/Spatial/msc/active/PATCH_2317_3_SP4/PATCH_2317_3_SP4_99/bin/OamCfg"
# p = PATCH_2317_3_SP4
# Return value would be : ./tmp1091/PATCH_2317_3_SP4/PATCH_2317_3_SP4_99/bin/OamCfg
proc GetCpTo {c a p} {
  set found 0
  foreach i [file split $a] {
    if ![string compare $i $p] {
      set found 1
    }
    if {$found == 1} {
      set c "$c/$i"
    }
  }
  return $c
}

set g(argc) $argc
set g(argv) $argv

set g(meta_index)           0
set g(meta_patchname_index) 1
set g(meta_module_index)    2
set g(meta_version_index)   3
set g(meta_cksum_index)     4
set g(meta_cpfrom)          5

CheckArguments
CreatePatchList
