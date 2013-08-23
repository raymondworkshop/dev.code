#!/opt/ActiveTcl/bin/tclsh

#
#  swpatch.tcl patch <srcfile> <dest> <desc>
#
#  swpatch.tcl view  <active> <module>
#
#  swpatch.tcl  unpatch <patchid>

package require Expect

if [info exists env(SPATIALROOT)] {
   set g(SPATIALROOT) $env(SPATIALROOT)
} else {
   set g(SPATIALROOT) /opt/Spatial/msc/active/tools
}

source $g(SPATIALROOT)/wssutil.tcl
if [catch {file readlink /opt/Spatial/msc/active} result] { 
    puts "Active link does not exists; Patch tool exiting"
    exit
 } else {
   	set my_version $result 
	set g(backupDir) /Spatial/msc/$my_version/swpatchBackup
 }   

 if ![file exists /Spatial/msc/$my_version/swpatchBackup] {
     catch {ExecuteCmd "$g(MKDIR) -p -m 777  $g(backupDir)"}  
 }
 # If there is a old swpatchBackup dir move everything to New backupdir
 if [file exists /opt/Spatial/msc/active/swpatchBackup] {
    if ![catch {set my_file [glob /opt/Spatial/msc/active/swpatchBackup/*]}] {
         puts "Copying patch files form old directory to new; This may take a while ..."
         foreach i $my_file {
	   catch {file copy  $i /Spatial/msc/$my_version/swpatchBackup/}
	   catch {file delete $i}
	 }
    } 
 }
 
#set g(backupDir)       /opt/Spatial/msc//space/swpatchBackup
#set g(backupDir)       /var/tmp/swpatchBackup
#set g(backupDir)      /opt/Spatial/msc/active/swpatchBackup

set g(backupAdminFile) $g(backupDir)/swpatch.adm
set g(logFileFd)       stderr

catch {unset patchAdmin}
set whoData            [eval exec $g(WHO) -m]
set g(userName)        [lindex $whoData 0]
set g(userLoc)         [lrange $whoData 1 end]
set g(myHostName)      [exec $g(HOSTNAME)]
set g(patchDesc)       ""
set g(noninteractive) 0

proc OutputInfo {msg} {
   global g

   foreach i [split $msg \n] {
      if {"$g(logFileFd)"!="stdout" && "$g(logFileFd)"!="stderr"} {
         puts $g(logFileFd) "INF: $msg"
      }
      puts stdout        "INF: $msg"
   }
   flush stdout
   flush $g(logFileFd)
}
proc OutputWarning {msg} {
   global g

   foreach i [split $msg \n] {
      if {"$g(logFileFd)"!="stdout" && "$g(logFileFd)"!="stderr"} {
         puts $g(logFileFd) "WRN: $msg"
      }
      puts stdout        "WRN: $msg"
   }
   flush stdout
   flush $g(logFileFd)
   incr g(warningCount)
}
proc OutputError {msg} {
   global g

   foreach i [split $msg \n] {
      if {"$g(logFileFd)"!="stdout" && "$g(logFileFd)"!="stderr"} {
         puts $g(logFileFd) "ERR: $msg"
      }
      puts stdout        "ERR: $msg"
   }
   flush stdout
   flush $g(logFileFd)
   incr g(errorCount)
}
proc GetPrompt {title width default {verifyProc ""}} {
   set rc $default
   set fs "\%${width}s"
   if {$default!=""} {
      set title "$title \[$default\]"
   }
   set done 0
   while {!$done} {
      puts -nonewline [format "${fs}: " $title]
      flush stdout
      set rrc [gets stdin]
    set rc [string trim $rrc]
 if {"$rc"==""} {set rc $default}
      if {"$verifyProc"!=""} {
         set done [eval [list $verifyProc $rc]]
      } else {
         set done 1
      }
   }
# puts ">> $rc"
   return $rc
}

proc GetYesNo {title width {default n}} {
   set rc $default
   set fs "\%${width}s"
   if {$default!=""} {
      set title "$title \[$default\]"
   }
   set done 0
   while {!$done} {
      puts -nonewline [format "${fs}: " $title]
      flush stdout
      set rc [gets stdin] 
      if {"$rc"==""} {set rc $default}
      set rc [string tolower $rc]
      switch -- $rc {
      {n} -
      {no}    {set rc no;  set done 1}
      {y} -
      {yes}   {set rc yes; set done 1}
      default {
         OutputError "Incorrect response '${rc}'.  Please type 'yes' or 'no'"
      }
      }
   }
   return $rc
}

proc VerifyPatchId {patchId} {
   global patchAdmin

   if {"$patchId"=="0"} {return 1}
   if [info exists patchAdmin($patchId)] {
      set ptype [lindex [set patchAdmin($patchId)] 0]
      if {"$ptype"=="PATCH"} {return 1}
   } else {
      OutputError "Patch $patchId not found"
   }
   return 0
}
proc VerifyUserName {userName} {
   return 1
}
proc VerifyFileReadable {fileName} {
   if {"$fileName"==""} {
      return 1
   }
   if ![file isfile $fileName] {
      OutputError "'$fileName' is not a file."
      return 0
   }
   if ![file readable $fileName] {
      OutputError "File '$fileName' not readable."
      return 0
   }
   return 1
}

proc VerifyDirectoryWritable {dirName} {
   if ![file isdirectory $dirName] {
      OutputError "'$dirName' is not a directory."
      return 0
   }
   if ![file writable $dirName] {
      OutputError "'$dirName' is not writable."
      return 0
   }
   return 1
}

proc VerifyUserSelectCommand {cmd} {
   set cmd [string tolower $cmd]
   set cmd [string range $cmd 0 0]
   switch -- $cmd {
       {v} - 
       {p} -
       {m} -
       {d} -
       {a} -
       {h} -
       {q}     {return 1}
       default {return 0}
   }
}

proc VerifyCardType {card} {
	global g
	if {$card==""} { OutputError "No Card specified"; return 0 }
	if [catch {exec matchCard.sh $card} result] { OutputError "$result"; return 0 }
	if [regexp -- {Warning} $result] { OutputError "$result"; return 0 }
	if [regexp -- {Error} $result] { OutputError "$result"; return 0 }
	return 1
}

proc VerifyStatus {status} {
   if { "$status"=="REGISTER" || "$status"=="ACTIVE" || "$status"=="INACTIVE" || "$status"=="" } {
      return  1
   } else {
     puts "status can only be specified as REGISTER or ACTIVE or INACTIVE."
     return 0 
   }
}

proc SaveAdminData {fileName} {
   global g patchAdmin

   if [catch {file rename -force $fileName ${fileName}_} result] {
      OutputWarning "$result"
   }
   if [catch {set fd [open $fileName w+]} result] {
      OutputError "$result"
      return 0
   }
   foreach i [lsort [array names patchAdmin]] {
      puts $fd "set patchAdmin($i) [list [set patchAdmin($i)]]"
   }
   close $fd
   return 1
}

proc ViewLog {  {module {}} {status {}} {card {} } { view_filename {}} } {
   global g patchAdmin

   puts "*** Switch Patch Status ***"
#   puts [format "PatchOp Patchid ModuleName Timestamp Username UserLocation  Description NewFilePatch OldFilePath CardType Status "]
   set noData     1
   set patchCnt   0
   set unpatchCnt 0
   set regCnt     0

   foreach i [lsort -integer [array names patchAdmin]] {
       set t10  [set patchAdmin($i)]
       set cmd  [lindex $t10 0]
       set pd   [lindex $t10 1]
       set un   [lindex $t10 2]
       set ul   [lindex $t10 3]
       set nfp  [lindex $t10 4]
       set nfc  [lindex $t10 5]
       set nfa  [lindex $t10 6]
       set ofp  [lindex $t10 7]
       set ofc  [lindex $t10 8]
       set ofa  [lindex $t10 9]
       set mn   [lindex $t10 10]
       set ver  [lindex $t10 14]
	   set pver [lindex $t10 11]

      if { "$module"!="" && "$module"!="$mn" } {continue}
      if { "$view_filename"!="" && "$view_filename"!="$ofp" } {continue}
      set cardt [lindex $t10 12]
      set st    [lindex $t10 13]
      if { "$status"!="" && "$status"!="$st" } {continue}
#      	  puts "cardt: $cardt"
      if { "$card"!="" && "$card"!="$cardt" } {continue}
      set t20  [ clock format $i -format "%a %b %d, %Y %H:%M:%S" ]
      set t20 [clock format $i -format "%Y%m%d%H%M%S"]

      if {"$cmd"=="PATCH"} {
          if { "$st"!="REGISTER" } { incr patchCnt } { incr regCnt }
      } 

      if {"$cmd"=="MODIFY" || "$cmd"=="DELETE"} {
         if { "$st"!="REGISTER" } {
			continue
         } else {			
           set ver [lindex $t10 11]
		   incr regCnt
         }		 
      } 
    
	   if {"$nfc"==""} {
		 set nfc "-"
	   }
	   if {"$ver"==""} {
		 set mnver [format "%-15s ver:%s,cksum:%s," $mn $pver $nfc]
	   } else {
		 set mnver [format "%-15s ver:%s,cksum:%s,"  $mn $ver $nfc]
	   }

   if {"$cmd"=="PATCH"} {
     puts [format "%-8s $i '$un' at $ul
   %-22s card#:$cardt $ofp
   Description: $pd" $st $mnver]
   } else {
     puts [format "%-7s $i  '$un' at $ul
   %-22s card#:$cardt $st $ofp
   Description: $pd" $cmd $mnver]
   }

      set noData 0
   }

   if {$noData} {
       puts "   <none>"
   } else {
	   puts ""
       puts "$patchCnt files PATCHED and $regCnt files REGISTERED"
   }
    puts ""
}

proc HistoryLog {  { module {} }  }  {
   global g patchAdmin

   puts "*** Switch Patch Status ***"
#   puts [format "PatchOp Patchid ModuleName Timestamp Username UserLocation  Description NewFilePatch OldFilePath CardType Status "]
   set noData     1
   set patchCnt   0
   set unpatchCnt 0
   set regCnt     0

	puts stdout $module 
   foreach i [lsort -integer [array names patchAdmin]] {
       set t10  [set patchAdmin($i)]
       set cmd  [lindex $t10 0]
       set pd   [lindex $t10 1]
       set un   [lindex $t10 2]
       set ul   [lindex $t10 3]
       set nfp  [lindex $t10 4]
       set nfc  [lindex $t10 5]
       set nfa  [lindex $t10 6]
       set ofp  [lindex $t10 7]
       set ofc  [lindex $t10 8]
       set ofa  [lindex $t10 9]
       set mn   [lindex $t10 10]

      if { "$module" != "" &&  "$module" != "$mn" } {continue}
      set cardt [lindex $t10 12]
      set st    [lindex $t10 13]
     # if { "$status" != " " && "$status" != "$st" } {continue}	
      #	puts "cardt: $cardt"
      set t20  [ clock format $i -format "%a %b %d, %Y %H:%M:%S" ]
      set t20 [clock format $i -format "%Y%m%d%H%M%S"]

      if { "$st"=="REGISTER"} {
           continue
       }
	   # UT : don't go for findVersion 
       #Finding version of the module
       #if ![ catch {exec findVersion $ofp} result] {
		#	set ver [lindex $result 3]
	   #} else {
	   	#	set ver [lindex $t10 11]
	   #}
	   if { "$cmd"=="PATCH" } { set ver [lindex $t10 14] } { set ver [lindex $t10 11] }
	   if { "$cmd"=="DELETE" } { set csum $ofc } { set csum $nfc }

       puts [format "%-7s $i '$un' at $t20
   %-15s  ver:$ver,cksum:$csum, card#:$cardt $st $ofp
   Description: $pd"  $cmd $mn]
 
       set noData 0
   }

    if {$noData} {
        puts "   <none>"
    } else {
    }
    puts ""
}

proc DisplayLog {  {module {}}  }  {
   global g patchAdmin

   puts "*** Switch Patch Status ***"
#   puts [format "PatchOp Patchid ModuleName Timestamp Username UserLocation  Description NewFilePatch OldFilePath CardType Status "]
   set noData     1
   set patchCnt   0
   set unpatchCnt 0
   set regCnt     0

   foreach i [lsort -integer [array names patchAdmin]] {
       set t10  [set patchAdmin($i)]
       set cmd  [lindex $t10 0]
       set pd   [lindex $t10 1]
       set un   [lindex $t10 2]
       set ul   [lindex $t10 3]
       set nfp  [lindex $t10 4]
       set nfc  [lindex $t10 5]
       set nfa  [lindex $t10 6]
       set ofp  [lindex $t10 7]
       set ofc  [lindex $t10 8]
       set ofa  [lindex $t10 9]
       set mn   [lindex $t10 10]

      if { "$module"!="" && "$module" != "$mn" } {continue}
# Deleting a Patch: Take module back to orginal unpatched state:
      }
}

proc DeletePatch {{patchId {}}} {
   global g patchAdmin

   while {1} {
      puts ""
     puts [format "%-12s  %-10s %-15s %-15s %-10s %s " "PatchId"  "Status" "Module" "Date/Time"  "CardType" "Filename"]
     puts [format "%-12s  %-10s %-15s %-15s %-10s %s " "-------"  "-------" "------" "--------"  "--------" "--------"]
      foreach i [lsort [array names patchAdmin]] {
         set t10   $patchAdmin($i)
         set ptype [lindex $t10 0]
         set pmodule [lindex $t10 10]
          set cardtype [lindex $t10 12]
         set pstatus [lindex $t10 13]
         if {"$ptype"=="DELETE" || "$ptype"=="MODIFY" || "$pstatus"=="FAILED" || "$pstatus"=="INACTIVE"} {continue}
         set pdesc [lindex $t10 1]
         set pfile [lindex $t10 7]
         set tmpst [lindex $t10 15]
         set pdate [clock format $i -format "%Y%m%d%H%M%S"]
	 #UT :
	 #set i "$i$tmpst"
         puts [format "%-12s  %-10s %-15s %-15s %-10s %s " $i $pstatus $pmodule $pdate $cardtype $pfile ]
         #puts [format "           %s" $pdesc]
      }
       if {$g(noninteractive) == 1 } {
           set command $patchId
       } else {
           set command [GetPrompt "Delete which patch Id (0=done)" 30 "" VerifyPatchId]
       }
      if {"$command"==0}  {break}
      if {"$command"==""} {continue}
      if [info exists patchAdmin($command)] {
         DoDelete $command
          if  {$g(noninteractive) == 1 } {return}
      } else {
         puts "ERR: Unknown patch id $command"
	 exit
      }
   }
}


proc DoDelete {patchId} {
    global g patchAdmin
    set patchRecord      [set patchAdmin($patchId)]
    set destFileAccess   [lindex $patchRecord 6]
    set destFilePath     [lindex $patchRecord 7]
    set destFileChecksum [lindex $patchRecord 5]
    set module [lindex $patchRecord 10]
    set version         [lindex $patchRecord 11]
    set destFileName     [file tail $destFilePath]
    set t11 [clock format $patchId -format "%Y%m%d%H%M%S"]
    set cardtype         [lindex $patchRecord 12] 
    set status 		[lindex $patchRecord 13] 
    set patchRecord [lappend  patchRecord  D]
    set patchAdmin($patchId)  $patchRecord
    SaveAdminData $g(backupAdminFile)
   if {"$status"=="REGISTER"} {
		array unset patchAdmin $patchId
        SaveAdminData $g(backupAdminFile)
		puts "Patch $patchId is not registered anymore for further applications"
		return 1
    } elseif {"$status"=="INACTIVE"} {
		array unset patchAdmin $patchId
        SaveAdminData $g(backupAdminFile)
		puts "Patch record ${patchId}(INACTIVE) is erased"
		return 1
    } else { 
		set status "REGISTER" 
	}

    if [file exists $g(backupDir)/${module}_orig] {
        set origFilePath  $g(backupDir)/${module}_orig
        if ![ExecuteCmd "$g(CKSUM) $origFilePath"] {
            OutputError "$g(cmdResult)"
            return 0
        }

        set origFileChecksum [format "%04x" [lindex $g(cmdResult) 0]]
        set origFileAccess [file attributes $origFilePath -permissions]
    } else {
        set  origFilePath ""
        set origFileChecksum ""
        set origFileAccess  ""
    }
	sleep 1
    set t10 [clock seconds]
    set patchAdmin($t10) [list DELETE $g(patchDesc) $g(userName) $g(userLoc) $origFilePath  $origFileChecksum $origFileAccess $destFilePath $destFileChecksum $destFileAccess $destFileName $version $cardtype REGISTER $patchId]
    SaveAdminData $g(backupAdminFile)
    puts "Patch $patchId is registered for delete."
    return 1
}

proc DeleteLog {  {module {}} {status {}} {card {} } {view_filename {}} }  {
   global g patchAdmin

   puts "*** Switch Patch Status ***"
#   puts [format "PatchOp Patchid ModuleName Timestamp Username UserLocation  Description NewFilePatch OldFilePath CardType Status "]
   set noData     1
   set patchCnt   0
   set unpatchCnt 0
   set regCnt     0
   set delCnt	  0

   foreach i [lsort -integer [array names patchAdmin]] {
       set t10  [set patchAdmin($i)]
       set cmd  [lindex $t10 0]
       set pd   [lindex $t10 1]
       set un   [lindex $t10 2]
       set ul   [lindex $t10 3]
       set nfp  [lindex $t10 4]
       set nfc  [lindex $t10 5]
       set nfa  [lindex $t10 6]
       set ofp  [lindex $t10 7]
       set ofc  [lindex $t10 8]
       set ofa  [lindex $t10 9]
       set mn   [lindex $t10 10]
       set ver  [lindex $t10 14]
	   set pver [lindex $t10 11]

      if { "$module"!="" && "$module"!="$mn" } {continue}
      if { "$view_filename"!="" && "$view_filename"!="$ofp" } {continue}
      set cardt [lindex $t10 12]
      set st    [lindex $t10 13]
      if { "$status"!="" && "$status"!="$st" } {continue}
#      	  puts "cardt: $cardt"
      if { "$card"!="" && "$card"!="$cardt" } {continue}
      set t20  [ clock format $i -format "%a %b %d, %Y %H:%M:%S" ]
      set t20 [clock format $i -format "%Y%m%d%H%M%S"]

     if {"$cmd"=="PATCH"} {
          if { "$st"!="REGISTER" } { incr patchCnt } { incr regCnt }
      } 

      if {"$cmd"=="MODIFY" || "$cmd"=="DELETE"} {
         if { "$st"!="REGISTER" } {
			continue
         } else {			
		   incr regCnt
         }		 
      } 
    
	  DoDelete $i
	  incr delCnt

      set noData 0
   }

   if {$noData} {
       puts "   <none>"
   } else {
	 puts ""
     puts "DELETE operation : Total $delCnt files"
   }
    puts ""
}

proc DoModify {patchId} {
   global g patchAdmin
   set patchRecord      [set patchAdmin($patchId)]
   set destFileAccess   [lindex $patchRecord 6]
   set destFilePath     [lindex $patchRecord 7]
   set destFileChecksum [lindex $patchRecord 5]
   set version 	        [lindex $patchRecord 11]
   set destFileName     [file tail $destFilePath]
   set t11 [clock format $patchId -format "%Y%m%d%H%M%S"]
   set cardtype         [lindex $patchRecord 12] 
   set status 		[lindex $patchRecord 13] 

    
   #set module [file tail $destFilePath]

   set origFilePath $g(backupDir)/${destFileName}_$t11
   set status "REGISTER"
    if ![file exists $origFilePath] {
	#IF THEREIS NO ORIGINAL FILE WE WILL REMOVE THE PATCH
        puts "No original file to Restore, Patch will be Deleted"
        set  origFilePath ""
        set origFileChecksum ""
        set origFileAccess  ""
    } else {
      set origFileAccess [file attributes $origFilePath -permissions]
      if ![file readable $origFilePath] {
         puts "ERR: Backup file $origFilePath not readable."
         return 0
      }
      if ![ExecuteCmd "$g(CKSUM) $origFilePath"] {
         OutputError "$g(cmdResult)"
         return 0
      }

      set origFileChecksum [format "%04x" [lindex $g(cmdResult) 0]]
   }
   set t10 [clock seconds]
   set patchAdmin($t10) [list MODIFY $g(patchDesc) $g(userName) $g(userLoc) $origFilePath  $origFileChecksum $origFileAccess $destFilePath $destFileChecksum $destFileAccess $destFileName $version $cardtype REGISTER $patchId]
   SaveAdminData $g(backupAdminFile)
   puts "Patch $patchId is Registered for modify"

   return 1
}

proc ModifyFile {{patchId {}}} {
   global g patchAdmin

   while {1} {
       puts ""
       puts [format "%-10s %-10s %-15s %-15s %-10s %s " "PatchId" "Status" "Module" "Date/Time" "CardType" "Filename"]
       puts [format "%-10s %-10s %-15s %-15s %-10s %s " "-------" "------" "------" "--------" "--------" "--------"]

       foreach i [lsort [array names patchAdmin]] {
           set t10   $patchAdmin($i)
           set ptype [lindex $t10 0]
           set cardtype [lindex $t10 12]
           set pstatus [lindex $t10 13]
           set pmodule [lindex $t10 10]
           
	 if {"$pstatus"=="REGISTER"} {
           continue
         }
         if { "$ptype" == "MODIFY" || "$ptype" == "DELETE" } {continue}
           set pdesc [lindex $t10 1]
           set pfile [lindex $t10 7]
           set pdate [clock format $i -format "%Y%m%d%H%M%S"]

         puts [format "%-10s %-10s %-15s %-15s %-10s %s" $i $pstatus $pmodule $pdate $cardtype $pfile]
         }
       if {$g(noninteractive) == 1 } {
           set command $patchId
       } else {
           set command [GetPrompt "Modify which patch Id (0=done)" 30 "" VerifyPatchId]
       }
      if {"$command"==0}  {break}
      if {"$command"==""} {continue}
      if [info exists patchAdmin($command)] {
         # Do not allow modify with currently active patchid
         #
         set patchRec    $patchAdmin($command)
         set stat     [lindex $patchRec 13]
         if {"$stat"=="ACTIVE"} {
            puts "patch $command is already active."
         } else {
            DoModify $command
         }
          if  {$g(noninteractive) == 1 } {return}
      } else {
         puts "ERR: Unknown patch id $command"
     }
   }
}


proc PatchFile {username module version  desc cardnum {status {REGISTER}} {srcfile {}} {destdir {}} {copyonly {0}} {execute {0}} } {
    switch -- $status {
        {REGISTER}  {
            set patchId [PatchFileRegister  $username $module $version  $desc $cardnum  $srcfile $destdir $copyonly $execute]
        }
        {ACTIVE}  {
            set patchId [PatchFileActive  $username $module $version  $desc $cardnum  $srcfile $destdir]
        }
    }
}


proc PatchFileRegister {username module version  desc cardnum  {srcfile {}} {destdir {}} {copyonly {0}} {execute {0}} } {
	global g patchAdmin

    set g(patchDesc) $desc

    if ![file exists $srcfile] {
        puts "srcfile \"$srcfile\" should exist for Patch REGISTER operation."
        return 0
    }

        
    set srcfileChecksum ""
    set srcfileAccess [file attributes $srcfile -permissions]
    set isPatched [isModulePatched $module $cardnum]
    set registeredPatchId [isModuleRegistered $module $cardnum $srcfile]
    #puts "RegisteredPatchId=$registeredPatchId"
    if { "$registeredPatchId"!= 0} {
	 puts "ERROR: Already patch is registered for the same module with PatchID= $registeredPatchId Delete it using DELETE operation"
     return 0
    }
 
 # UT :
 #   if !{$isPatched} {
 #       # Get Original File for this module
 #       set ipAddr [GetOneOfCardType  $cardtype]
 #       if {"$ipAddr"==""} {
 #           puts "can not access any card of cardtype $cardtype"
 #           return 0
 #       }
 #           
 #      if [catch {exec $g(RCP) -p $ipAddr:$destdir/$module $g(backupDir)/${module}_orig}   result] {
 #           if [regexp -- {No such file or directory} $result] {
 #           } else {
 #                  puts "$g(RCP) -p  $ipAddr:$destdir/$module $g(backupDir)/${module}_orig failed"
 #                  puts "$result"
 #           }
 #       } else {
 #           set destfileAccess [file attributes $g(backupDir)/${module}_orig -permissions]
 #       }
 #           
 #   } 

    # If last character is not /, append a / to the directory name.
    regsub {([^/])$} $destdir {\1/} destdir	
	#set destfile $destdir$module
	# UT : Instead of module name, we are writing srcfile name to make destfile name
	if { $g(noninteractive)==1 } {
		set tname [file tail $srcfile]
		set destfile $destdir$tname
	} else {
		set destfile $destdir$module
	}
    set destfileChecksum  ""
    if ![info exists destfileAccess] {
        set destfileAccess   ""
    }
    

   
    # UT: following sleep is required to overcome repeated id problem
	sleep 1
	set patchId [clock seconds]
    set patchStr [clock format $patchId -format "%Y%m%d%H%M%S"]

#    set backupFilePath $g(backupDir)/${module}_${patchStr}
#    if ![ExecuteCmd "$g(CP) -p $srcfile $backupFilePath"] {
#        OutputError "$g(cmdResult)"
#        return 0
#    }
#    set srcfile $backupFilePath
#    # if ![ExecuteCmd "$g(CHMOD) 766 $backupFilePath"] {
#     #   OutputWarning "$g(cmdResult)"
#    # }
#    
#	# FINDING WORKING PATCH
#      if ![ catch {exec which $module} result] {
#	set wp $result
#	}
#
#      # FINDING VERSION OF THE MODULE

	if ![ catch {exec findVersion $srcfile} result] {
		set ver [lindex $result 3]
		set version $ver
	} else {
		set ver $version
	}

	if ![ catch {exec /usr/bin/cksum $srcfile} result] {
		set srcfileChecksum [lindex $result 0]
	} else {
		set srcfileChecksum ""
	}


	
	set patchAdmin($patchId) [list PATCH $g(patchDesc) $g(userName) $g(userLoc) $srcfile $srcfileChecksum $srcfileAccess $destfile $destfileChecksum $destfileAccess $module $version $cardnum REGISTER $ver $copyonly $execute]
    SaveAdminData $g(backupAdminFile)	
    return  $patchId
}

proc PatchFileActive {username module version  desc cardnum  {srcfile {}} {destdir {}}} {
   global g patchAdmin

    set g(patchDesc) $desc
    
    set isPatched [isModulePatched $module $cardnum]

    #if {"$cardtype"!="all"} {
    #    puts "PATCH ACTIVE operation is supported only for cardtype \"all\"."
    #    return 0
    #}

#    if !{$isPatched} {
#        # For Patch ACTIVE operation for the first patch the original file is supplied in the
#        # srcfile variable. If the srcfile does not exist it implies that there is no original
#        # file.
#
#        if [info exists $srcfile] {
#            if [catch {exec $g(CP) -p  $srcfile $gbackupdir/${module}_orig}   result] {
#                puts "Problem copying original file for the first patch."
#                return 0
#            }
#        }
# 
#    }
    # If last character is not /, append a / to the directory name.
    regsub {([^/])$} $destdir {\1/} destdir
	if { $g(noninteractive)==1 } {
		set tname [file tail $srcfile]
		set destfile $destdir$tname
	} else {
		set destfile $destdir$module
	}
    
	# Check if any patch is already ACTIVE for this module
	if {$g(noninteractive)==1} {	
		foreach patchId [array names patchAdmin] {
			set patchRec $patchAdmin($patchId)
			set ptype [lindex  $patchRec  0]
			set pmodule [lindex $patchRec 10]
			set pcardnum [lindex $patchRec 12]
			set pstatus [lindex $patchRec 13]
			set pdestfile [lindex $patchRec 7]
			if {"$ptype"!="PATCH"} {continue}
			if {"$pstatus"!="ACTIVE"} {continue}
			if {"$module"=="$pmodule" && "$pcardnum"=="$cardnum" && "$destfile"=="$pdestfile"} { 
				puts "ERROR: Card $cardnum : Already ACTIVE patch found : $patchId"
				puts "\t So DO NOT select card $cardnum and try again"
				return 0 
			}
		}
	}
	set temp [exec matchCard.sh $cardnum]
	set ip [lindex $temp 0]

	set destfileChecksum  ""
    set destfileAccess   ""    
    if ![file exists $destfile] {
        puts "ERROR: Card $cardnum : Destination file \"$destfile\" should exist for PATCH ACTIVE operation."
		return 0
    }
    
	sleep 1
	set patchId [clock seconds]
    set patchStr [clock format $patchId -format "%Y%m%d%H%M%S"]
    
	if [catch {exec /usr/bin/rsh $ip "/opt/Spatial/msc/active/tools/findVersion ${destfile} " 2> /tmp/deleteme} result] {
		puts "ERROR: Card $cardnum: $result"
		return 0
	} else {
		if [ catch {exec cat /tmp/deleteme | wc -l} err ] { 
			puts "ERROR: Card $cardnum : $err"
			return 0
		}
		if {"$err"!="0"} {
			set tmp [exec cat /tmp/deleteme]
			puts "ERROR: Card $cardnum : $tmp  \[PATCH ACTIVE operation\]"
			return 0
		}
	}
    set version [lindex $result 3]

	if [catch {exec /usr/bin/rsh $ip "/usr/bin/cksum ${destfile} " 2> /tmp/deleteme} result] {
		puts "ERROR: Card $cardnum : $result"
		return 0
	} else {
		set destfileChecksum [lindex $result 0]
	}

#    set backupFilePath $g(backupDir)/${module}_${patchStr}
#    if ![ExecuteCmd "$g(CP) -p $destfile $backupFilePath"] {
#        OutputError "$g(cmdResult)"
#        return 0
#    }

    # if ![ExecuteCmd "$g(CHMOD) 766 $backupFilePath"] {
    #    OutputWarning "$g(cmdResult)"
    # }
	
	# Delete any INACTIVE or REGISTERed patch for this module
	if {$g(noninteractive)==1} {
		foreach xpatchId [array names patchAdmin] {
			set patchRec $patchAdmin($xpatchId)
			set ptype [lindex  $patchRec  0]
			set pmodule [lindex $patchRec 10]
			set pcardnum [lindex $patchRec 12]
			set pstatus [lindex $patchRec 13]
			set pdestfile [lindex $patchRec 7]
			if {"$ptype"!="PATCH"} {continue}
			if {"$pstatus"!="INACTIVE" && "$pstatus"!="REGISTER"} {continue}
			if {"$module"=="$pmodule" && "$pcardnum"=="$cardnum" && "$destfile"=="$pdestfile"} {
				unset patchAdmin($xpatchId)
			}
		}
	}
   
	# While viewing, we see srcfilechecksum for the modules, so write destfilechecksum as srcfilechecksum too !!
	set patchAdmin($patchId) [list PATCH $g(patchDesc) $g(userName) $g(userLoc) $srcfile $destfileChecksum "" $destfile "" "" $module $version $cardnum ACTIVE]
    SaveAdminData $g(backupAdminFile)
    return  $patchId
}

proc ApplyCopyExecute {option_l option_skip} {
	global g patchAdmin
	set pid1 [pid]
    set tfile /var/tmp/do_patch_${pid1}.log
	if [catch {set tfd [open $tfile w]} result] {
		puts "ERROR: $result"
		return 1
	}
	puts "Log file is located at : $tfile"
	set curTime [exec date]
	puts $tfd "Log of patch process on : $curTime"

	set bspmlist {}
	set tflag "0"
	set msg "
-------------------------------------------
Start of applying Offline Patches
-------------------------------------------
"
	set skiplist [split $option_skip ,]

	foreach patchId  [array names patchAdmin] {

		# Necessary to check existance, because we may have deleted
		# the record while making patchActive...
		if ![info exists patchAdmin($patchId)] { continue }
		set patchRec $patchAdmin($patchId)
		set patchOp  [lindex $patchRec 0]
		set srcfile  [lindex $patchRec 4]
		set destfile [lindex $patchRec 7]
		set destdir  [file dirname $destfile]
		set cardNum	 [lindex $patchRec 12]
		set status   [lindex $patchRec 13]
		set copyonly [lindex $patchRec 15]
		set execute	 [lindex $patchRec 16]

		if { "$status"!="REGISTER" } { continue }
		if { "$copyonly"!="1" && "$execute"!="1" && "$g(out_of_service)"!="1"} { continue }
		set ix [lsearch -exact $skiplist $cardNum]
		if { $ix >= 0 } {
			puts "skipping card $cardNum as per -s flag"
			puts $tfd "skipping card $cardNum as per -s flag"
			continue
		}

		set temp [exec matchCard.sh $cardNum]
		set ip [lindex $temp 0]

		catch { [exec /usr/sbin/ping $ip 2] } res
		if ![regexp "is alive" $res] {
			if {"$option_l"=="1"} {
				puts "Ignoring card $cardNum which did not respond to ping"
				puts $tfd "Ignoring card $cardNum which did not respond to ping"
				continue
			} else {
				puts ""
				puts "Could not ping to card $cardNum"
				puts "Either select an option to ignore such cards or make the card pingable"
				puts ""
				puts $tfd ""
				puts $tfd "Could not ping to card $cardNum"
				puts $tfd "Either select an option to ignore such cards or make the card pingable"
				puts $tfd ""
				close $tfd
				return 1
			}
		}


		if { "$tflag"=="0" } {
			if {"$g(out_of_service)"=="1"} {
				puts "\nYOU HAVE SELECTED OUT OF SERVICE PATCHING OPTION"
				puts "*************************************************"
				puts $tfd "\nYOU HAVE SELECTED OUT OF SERVICE PATCHING OPTION"
				puts $tfd "*************************************************\n"
			}
			puts "$msg"
			puts $tfd "$msg"
			set tflag "1"
		}
		
		if {"$g(out_of_service)"=="1"} {
			# Stop the Platform on that card
			set cmd "/usr/bin/rsh -n -l root $ip \". /.profile; /etc/init.d/BsPmMonitor stop\""
			if [catch {eval exec $cmd > /tmp/deleteme} result] {
				puts "ERR: $result"
				puts $tfd "\t ERR: $result"
				close $tfd
				return 1
			}
			set tmp [exec cat /tmp/deleteme]
			set cmpstr "The BsPmMonitord daemon has stopped successfully"
			if [regexp -- $cmpstr $tmp] {
				if {[lsearch -exact $bspmlist $ip] > -1 } {
				} else {
					lappend bspmlist $ip
					puts "\tStopped platform on $ip"
					puts $tfd "\tStopped platform on card $cardNum"
				}
			}
		}

		if {"$g(out_of_service)"=="1" && "$execute"!="1"} {
			set outofservice_copy 1
		} else {
			set outofservice_copy 0
		}

		if {"$copyonly"=="1" || "$outofservice_copy"=="1"} {
			puts "\tRenaming existing $destfile (if any)"
			puts $tfd "\tRenaming existing $destfile (if any)"
			if [catch {exec /usr/bin/rsh $ip "mv -f ${destfile} ${destfile}_" 2> /tmp/deleteme} result] {
				puts "ERROR: $result"
				puts $tfd "ERROR: $result"
				close $tfd
				return 1
			} else {
				set mvresult [exec cat /tmp/deleteme]
				puts "\t $mvresult"
				puts $tfd "\t $mvresult"
			}

			puts "\tCopying $srcfile to $destfile on card $cardNum"
			puts $tfd "\tCopying $srcfile to $destfile on card $cardNum"
			if [catch {exec /usr/bin/rcp -p $srcfile $ip:$destfile} result] {
				puts "ERROR: $result"
				puts $tfd "ERROR: $result"
				close $tfd
				return 1
			}
			puts ""
			puts $tfd ""
		}
		if {"$execute"=="1"} {
			puts "\tCopying $srcfile to $destfile on card $cardNum"
			puts $tfd "\tCopying $srcfile to $destfile on card $cardNum"
			if [catch {exec /usr/bin/rcp -p $srcfile $ip:$destfile} result] {
				puts "ERROR: $result"
				puts $tfd "ERROR: $result"
				close $tfd
				return 1
			}
			puts "\tMaking $destfile executable on card $cardNum"
			puts $tfd "\tMaking $destfile executable on card $cardNum"
			if [catch {exec rshCmd "usr/bin/chmod 777 $destfile" $cardNum} result] {
				puts "ERROR: $result"
				puts $tfd "ERROR: $result"
				close $tfd
				return 1
			}
			puts "\tExecuting $destfile on card $cardNum"
			puts $tfd "\tExecuting $destfile on card $cardNum"
			if [catch {exec rshCmd "$destfile" $cardNum > /tmp/deleteme} result] {
				puts "ERROR: $result"
				puts $tfd "ERROR: $result"
				close $tfd
				return 1
			} else {
				set runresult [exec cat /tmp/deleteme]
				puts "\t $runresult"
				puts $tfd "\t $runresult"
			}
			puts ""
			puts $tfd ""
		}
		MakePatchActive $patchId
		SaveAdminData $g(backupAdminFile)
		}
	# Now restart platform on the cards where we could successfully stop it before.	
	foreach ip $bspmlist {
		puts "\tStarting platform on $ip"
		puts $tfd "\tStarting platform on $ip"
		set cmd "/usr/bin/rsh -n -l root $ip \". /.profile; /etc/init.d/BsPmMonitor start\""
		if [catch {eval exec $cmd > /tmp/deleteme} result] {
			puts "ERR: $result"
			puts $tfd "\t ERR: $result"
		}
	}

	if { "$tflag"=="1" } {
		puts "-----------------------------------------"
		puts "End of applying Offline Patches"
		puts "------------------------------------------"
		puts $tfd "-----------------------------------------"
		puts $tfd "End of applying Offline Patches"
		puts $tfd "------------------------------------------"
	}
	puts $tfd ""
	close $tfd
	return 0
}

proc ApplyPatch {option_n option_g option_l option_e option_skip } {
    global g patchAdmin
	
	set result [ApplyCopyExecute $option_l $option_skip]
	if { "$result"!="0" } {
		return
	} else {
		set cnt 0
		set skiplist [split $option_skip ,]
		foreach patchId [array names patchAdmin] {
			set patchRec $patchAdmin($patchId)
			set status [lindex $patchRec 13]
			set cardNum [lindex $patchRec 12]
			if { "$status"=="REGISTER" } {
				if {[lsearch -exact $skiplist $cardNum] > -1 } { 
					continue 
				} else {
					set cnt 1
					break
				}
			}
		}
		if { "$cnt" == "0" } { return }
	}

    set pid1 [pid]
    set infile /var/tmp/applyPatchInput.${pid1}
    set outfile /var/tmp/applyPatchOutput.${pid1}
    
    if [catch {set fd [open  $infile w+]} result] {
      OutputError "$result"
      return
    }

   # puts $fd "patchId,srcfile,destdir,cardType"
    foreach patchId  [array names patchAdmin] {
        set patchRec $patchAdmin($patchId)
		set patchOp  [lindex $patchRec 0]
        set srcfile  [lindex $patchRec 4]
        set destfile [lindex $patchRec 7]
        set destdir  [file dirname $destfile]
        set cardNum	 [lindex $patchRec 12]
        set status   [lindex $patchRec 13]
		set copyonly [lindex $patchRec 15]
		set execute	 [lindex $patchRec 16]

	# This condition is same for both patch& unpatch
        if {"$status"=="REGISTER"} {
			puts $fd "$patchId,$patchOp,$srcfile,$destfile,$cardNum"
        }
    }
    close $fd

    puts "Starting ApplyPatch.sh to copy patch to applicable cards."
#    set cmd "|/opt/Spatial/msc/active/installation/applyPatch.sh -f $infile -o $outfile |& cat" 
#
#   if [catch {set fd [open "$cmd"  r]} g(cmdResult)] {
#      puts "$g(cmdResult)"
#   } else {
#      set g(cmdResult) ""
#      while {[gets $fd line] > -1} {
#         append g(cmdResult) "$line\n"
#         puts "$line"
#         flush stdout
#      }
#      catch {close $fd}
#   }

	puts ""
	
	if ![string compare $option_n "1"] {
		set option_n -n
	} else {
		set option_n 0
	}

#	Don't expose option_g to users
#	if ![string compare $option_g "1"] {
#		set option_g -g
#	} else {
#		set option_g 0
#	}

	if ![string compare $option_l "1"] {
		set option_l -l
	} else {
		set option_l 0
	}

	if ![string compare $option_e "1"] {
		set option_e -e
	} else {
		set option_e 0
	}

	if {[string length $option_skip] > 0} {
		set option_skip $option_skip
	} else {
		set option_skip 0
	}
	if { $g(noninteractive)==1 } {
		if { "$option_skip"==0 } {
spawn /opt/Spatial/msc/active/installation/applyPatch.sh $option_n $option_l $option_e -f $infile -o $outfile
interact
wait
		} else {
			set option_skip ,$option_skip,
			#puts "skip list before spawning=$option_skip"
spawn /opt/Spatial/msc/active/installation/applyPatch.sh -s $option_skip $option_n $option_l $option_e -f $infile -o $outfile
interact
wait
		}
	} else {
spawn /opt/Spatial/msc/active/installation/applyPatch.sh -n -f $infile -o $outfile 
interact
wait
	}

    if [catch {set fd1 [open  $outfile r]} result] {
        OutputError "$result"
        return
    }

    while {[gets $fd1 line] > -1} {
		if ![string compare $line "reboot"] {
		    close $fd1
		    SaveAdminData $g(backupAdminFile)    
			exec "reboot"
		}
        set patchId [lindex $line 0]
        set status  [lindex $line 1]
        if [isValid $patchId] {
            set patchRec $patchAdmin($patchId)
            set oper [lindex $patchRec 0]
			set module  [lindex $patchRec 10]
            switch -- $oper {
              {PATCH}  {
                 # Process the PATCH record
                 if {"$status"=="SUCCESS"} {
                    MakePatchActive  $patchId 
					# updating the version *******
                    # FINDING WORKING PATCH
					set ver NEW					
                    
					if {"$module"=="TOOLS"} {
						set wp [lindex $patchRec 7]
					} else {
						if ![ catch {exec which $module} result] {
							set wp $result
						}	
					}
                    if ![ catch {exec findVersion $wp} result] {
                      set ver [lindex $result 3]
                    }
					if ![ catch {exec /usr/bin/cksum $wp} result] {
						set srcfileChecksum [lindex $result 0]
					} else {
						set srcfileChecksum ""
					}

					set patchRec $patchAdmin($patchId)
					set patchRec [lreplace $patchRec 5 5 $srcfileChecksum]
                    set patchRec [lreplace $patchRec 14 14  $ver]
                    set patchAdmin($patchId)  $patchRec
                 } else {
                    #UT: following two lines commented to avoid re-registering failed patches
					#set patchRec [lreplace $patchRec 13 13  FAILED]
                    #set patchAdmin($patchId)  $patchRec
                 }
              }

              {MODIFY} {
                # Process the MODIFY RECORD
                 if {"$status"=="SUCCESS"} {
                    set patchRec [lreplace $patchRec 13 13 DONE]
                   # Process  the associated patch Id with the MODIFY record
                   set  rpatchId [lindex $patchRec 14]
                   MakePatchActive  $rpatchId 
	            # updating the version *******
                    # FINDING WORKING PATCH
		    set ver NEW
                    if ![ catch {exec which $module} result] {
                       set wp $result
                       }
                       if ![ catch {exec findVersion $wp} result] {
                      set ver [lindex $result 3]
                       }
                     set patchRec $patchAdmin($patchId)
		     set patchRec [lreplace $patchRec 14 14  $ver]
                     set patchAdmin($patchId)  $patchRec
                 } else {
                    set patchRec [lreplace $patchRec 13 13  FAILED]
                 }
                 set patchAdmin($patchId)  $patchRec
              }
            
              {DELETE} {
                # Process the DELETE RECORD
                 if {"$status"=="SUCCESS"} {
                    set patchRec [lreplace $patchRec 13 13 DONE]
                   # Process  the associated patch Id with the DELETE record
                   set  rpatchId [lindex $patchRec 14]
				   #UT: don't make all the patches inactive for this module
                   if { $g(noninteractive)==1 } {
						MakePatchInactive $rpatchId
				   } else {
					   MarkAllInactive $rpatchId
				   }

                 } else {
                    #set patchRec [lreplace $patchRec 13 13  FAILED]
                 }
                set patchAdmin($patchId)  $patchRec

             }

         }
    } else {
            OutputWarning "Invalid patch id $patchId"
        }
    }
    close $fd1
    SaveAdminData $g(backupAdminFile)    
    ViewLog "" "REGISTER" ""
}

proc MakePatchActive {patchId} {
# When a patch is made active the previously active patch becomes inactive for the same module.
    global g patchAdmin

    if ![info exists patchAdmin($patchId)] {
       puts "Missing patch id $patchId"
    }
	set prevActive 0
    set patchRec $patchAdmin($patchId)
    set module  [lindex $patchRec 10]
	set cardnum [lindex $patchRec 12]
	set destfile [lindex $patchRec 7]

    foreach key [array names patchAdmin] {
         set  record  $patchAdmin($key)
         set mod  [lindex $record 10]
		 set cnum [lindex $record 12]
         set  stat [lindex $record 13]
		 set pdestfile [lindex $record 7]

         if {"$mod"!="$module"} {
             continue
         }
         if {"$stat"=="ACTIVE" && "$cnum"=="$cardnum" && "$destfile"=="$pdestfile"} {
             set prevActive $key
         }
		 if {"$stat"=="INACTIVE" && "$cnum"=="$cardnum" && "$destfile"=="$pdestfile"} {
			array unset patchAdmin $key
			#puts "\tINF: Erased record $key : previously INACTIVE patch"
         }
    }
	if {"$prevActive"!="0"} {
		set  record  $patchAdmin($prevActive)
		set record [lreplace $record 13 13 INACTIVE]
        set patchAdmin($prevActive) $record 
	}
    set patchRec [lreplace $patchRec 13 13 ACTIVE]
    set patchAdmin($patchId) $patchRec
}    

#
# Mark All patches for a particular module as Inactive. For convenience, user is allowed
# to pass a patchId as argument rather than module name. Only records with ACTIVE or INACTIVE
# status are considered.
#
proc MarkAllInactive {patchId} {
    global g patchAdmin

    if ![info exists patchAdmin($patchId)] {
       puts "Missing patch id $patchId"
    }
    set patchRec $patchAdmin($patchId)
    set module  [lindex $patchRec 10]

    foreach key [array names patchAdmin] {
         set  record  $patchAdmin($key)
         set mod  [lindex $record 10]
         set  stat [lindex $record 13]
         if {"$mod"!="$module"} {
             continue
         }
         if {"$stat"=="ACTIVE" || "$stat"=="INACTIVE"} {
             set record [lreplace $record 13 13 INACTIVE]
             set patchAdmin($key) $record
         }
    }
} 

# make only this patch inactive
proc MakePatchInactive {patchId} {
	global g patchAdmin

	if ![info exists patchAdmin($patchId)] {
       puts "Missing patch id $patchId"
    }
    set patchRec $patchAdmin($patchId)
	set mod [lindex $patchRec 10]
	set card [lindex $patchRec 12]
	set dfile [lindex $patchRec 7]
	# There should be only one INACTIVE patch at a time for particular module.
	# If there is any previously INACTIVE module for the same thing, erase it 
	# from the list. We only keep backup upto one level.
    foreach key [array names patchAdmin] {
		set record $patchAdmin($key)
		set cmd [lindex $record 0]
        set destfile [lindex $record 7]
        set cardnum	 [lindex $record 12]
        set status   [lindex $record 13]
		set module   [lindex $record 10]
		if {"$cmd"!="PATCH"} { continue }
		if {"$status"!="INACTIVE"} { continue }
		if {"$cardnum"!="$card" } { continue }
		if {"$module"!="$mod" } { continue }
		if {"$destfile"!="$dfile" } { continue }
		array unset patchAdmin $key      
		puts "Patch record ${key}(old INACTIVE) is erased"
    }
	
	set patchRec [lreplace $patchRec 13 13 INACTIVE]
    set patchAdmin($patchId) $patchRec
	SaveAdminData $g(backupAdminFile)
}

# Identify if the supplied patchId is a valid one.
proc isValid {patchId} {
    global g patchAdmin

    set patchIdList [array names patchAdmin]
    if {[lsearch -exact $patchIdList $patchId] > -1} {
        return 1
    } else {
        return 0
    }
}
# Identify if there are any patches on a module. The patches can be in
# ACTIVE, INACTIVE or REGISTER state.

proc isModulePatched {module {cardnum {}} } {
    global g patchAdmin
    foreach patchId [array names patchAdmin] {
        set patchRec $patchAdmin($patchId)
        set ptype [lindex  $patchRec  0]
        set pmodule [lindex $patchRec 10]
		set pcardnum [lindex $patchRec 12]
        if {"$ptype"!="PATCH"} {continue}
		if {$g(noninteractive)==1} {	
	        if {"$module"=="$pmodule" && "$pcardnum"=="$cardnum"} { return 1 }
		} else {
			if {"$module"=="$pmodule"} { return 1 }
		}
    }
    return 0
}

proc GetOneOfCardType {cardtype} {
    global g patchAdmin

    set ipList {}

    catch {exec /usr/bin/getent hosts LOCAL_IF_A} result
    set localip [lindex $result 0]
    
    catch {exec /opt/Spatial/msc/active/tools/pingCards $cardtype} result
    foreach line [split $result \n] {
        if [regexp {([^ ]*) is alive} $line junk ipaddr] {
            lappend ipList $ipaddr
        }
    }

    if [llength $ipList] {
        if {[lsearch $ipList $localip] > -1 } {
            return $localip
        } else {
            return [lindex $ipList 0]
        }
    } else {
    return ""
    }
}
proc isModuleRegistered {module {cardnum {}} {srcfile {}} } {
    global g patchAdmin
    foreach patchId [array names patchAdmin] {
        set patchRec $patchAdmin($patchId)
        set ptype [lindex  $patchRec  0]
        set pmodule [lindex $patchRec 10]
        set pstatus [lindex $patchRec 13]
		set pcardnum [lindex $patchRec 12]
        if {"$pstatus"!="REGISTER"} {continue}
		if {$g(noninteractive)==1} {
			set psrcfile [lindex $patchRec 4]
			if { "$module"!="TOOLS" && "$module"!="SCRIPTS" } {
		        if { "$module"=="$pmodule" && "$pcardnum"=="$cardnum" } {return $patchId}
			} else {
				if { "$module"=="$pmodule" && "$pcardnum"=="$cardnum" && "$srcfile"=="$psrcfile"} { return $patchId }
			}
		} else {
			if { "$module"=="$pmodule" } {return $patchId}
		}
    }
    return 0
}

#List intersect3: Compares 2 lists and detects entries that only exist in list 1, only exist in list 2 or that exist in both lists

#Parameters:

#list1 - The first input list 
#list2 - The second input list 
#inList1 - Name of the list in which to put list1 only elements 
#inList2 - Name of the list in which to put list2 only elements 
#inBoth - Name of the list in which to put elements in list1 & list2

proc intersect3 {list1 list2 inList1 inList2 inBoth} {

     upvar $inList1 in1
     upvar $inList2 in2
     upvar $inBoth  inB

     set in1 [list]
     set in2 [list]
     set inB [list]

     set list1 [lsort $list1]
     set list2 [lsort $list2]

     # Shortcut for identical lists is faster
     if { $list1 == $list2 } {
         set inB $list1
     } else {
         set i 0
         foreach element $list1 {
             if {[set p [lsearch [lrange $list2 $i end] $element]] == -1} {
                 lappend in1 $element
             } else {
                 if { $p > 0 } {
                     set e [expr {$i + $p -1}]
                     foreach entry [lrange $list2 $i $e] {
                         lappend in2 $entry
                     }
                     incr i $p
                 }
                 incr i
                 lappend inB $element
             }
         }
         foreach entry [lrange $list2 $i end] {
             lappend in2 $entry
         }
     }
 } 
#
# Sync procedure ensures that we have same patch database information
# on both the SAM Cards.
#
#
proc Synch {} {
    global g patchAdmin
    
    if [catch {exec /usr/bin/getent hosts LOCAL_IF_A} result] {
        OutputError "Could not determine the LOCAL_IF_A. Your hosts file might be corrupt."
        exit
    }
    set localip [lindex $result 0]

    if [catch {exec /usr/bin/getent hosts OAM_PRIMARY_IF_A} result] {
        OutputError "Could not determine the OAM_PRIMARY_IF_A. Your hosts file might be corrupt."
        exit
    }
    set  oama [lindex $result 0]

    if [catch {exec /usr/bin/getent hosts OAM_SECONDARY_IF_A} result] {
        OutputError "Could not determine the OAM_SECONDARY_IF_A. Your hosts file might be corrupt."
	return 0
    }
    set  oamb [lindex $result 0]
    if {"$localip"=="$oama"} {set otherip  $oamb}  {set otherip $oama}

    if [catch {exec /usr/sbin/ping  $otherip} result] {
        OutputWarning "Could not ping other SAM card."
	return 0
    }
    
     if ![file isdirectory $g(backupDir)] {
        # Check if it exist on the other side
        # puts " rsh $otherip $g(LS) -d $g(backupDir)"
        catch {exec rsh $otherip $g(LS) -d $g(backupDir)} result
         if [regexp -- {No such file or directory} $result] {
             # The backup directory does not exist on the other side also. This is a valid situation and it happend
             # first time the tool is being used.
             if ![ExecuteCmd "$g(MKDIR) -p -m 777  $g(backupDir)"] {
                 OutputError "$g(cmdResult)"
                 exit 1
             }
             if ![file exists $g(backupAdminFile)] {
                 # If backupAdmin file has to be created assign it a very old time stamp
                 if ![ExecuteCmd "$g(TOUCH) -t 197001010000 $g(backupAdminFile)"] {
                     OutputWarning "$g(cmdResult)"
                 }
             }
             
             return 0
         } else {
             # The backup directory exists on the other side. So copy it to the current side.
             if [catch {exec $g(RCP) -p  -r $otherip:$g(backupDir)  [file dirname $g(backupDir)]}   result] {
                 puts "failed $g(RCP) -p  $otherip:$g(backupDir)  $g(backupDir)/.."
                 puts "$result"
                 exit
             }
             return 0
         }
    } else {
        #puts "rsh $otherip $g(LS) -d $g(backupDir)"
        catch {exec rsh $otherip $g(LS) -d $g(backupDir)} result
        #puts "$result"
         if [regexp -- {No such file or directory} $result] {
             # The backup directory does not exist on the other side. This situation will be fixed
             # when patch tool is invoked there.
             return 0
         }
    }

    if [catch {set g(logFileFd) [open /var/tmp/swpatch.log w+]} result] {
        OutputWarning "$result"
    }

    
    if ![file writable $g(backupDir)] {
        if ![ExecuteCmd "$g(CHMOD) 766 $g(backupDir)"] {
            OutputError "$g(cmdResult)"
            exit 1
        }
    }

    if ![file exists $g(backupAdminFile)] {
        # If backupAdmin file has to be created assign it a very old time stamp
           if ![ExecuteCmd "$g(TOUCH) -t 197001010000 $g(backupAdminFile)"] {
            OutputWarning "$g(cmdResult)"
        }
    }
    
    if [file readable $g(backupAdminFile)] {
        if [catch {source $g(backupAdminFile)} result] {
            OutputError "$result"
            exit 1
        }
    }

    set patchList1 [array names patchAdmin]
    set patchAdminBackupList [array get patchAdmin]
    #puts "/bin/ls -1 $g(backupDir)/*"
    catch {exec /bin/ls -1 $g(backupDir)/*}  fileList1

    # Make a local copy of the remote backupAdminFile
    set pid [pid]
    if [catch {exec $g(RCP) -p $otherip:$g(backupAdminFile) /tmp/swpatch.adm.$pid} result] {
#        puts " $g(RCP) $otherip:$g(backupAdminFile) /tmp/swpatch.adm.$pid failed"
#        puts "$result"
        return 0
    }

    set time1 [file mtime $g(backupAdminFile)]
    set time2 [file mtime /tmp/swpatch.adm.$pid]
    if { $time2 > $time1 } {
    	if [info exists patchAdmin] {
            unset patchAdmin
        }
        file copy -force -- /tmp/swpatch.adm.$pid $g(backupAdminFile)
    } else {
        return 0
    }
    
     
     if [catch {source /tmp/swpatch.adm.$pid} result] {
         puts "problem getting new swpatch.adm records from the remote sam."
         puts "$result"
         return 0
     }

    set patchList2 [array names patchAdmin]
    set inList1 {}
    set inList2 {}
    set inBoth {}
     intersect3 $patchList1 $patchList2 inList1 inList2 inBoth
    if { [llength $inList2] > 0 } {
        #puts "Bringing patchRecords $inList2 from the other SAM."
        
        # UT : Now we don't keep backup, so no such files exist
		#foreach patchId $inList2 {
        #    set patchStr [clock format $patchId -format "%Y%m%d%H%M%S"]
        #    set patchRec   $patchAdmin($patchId)
        #    set module   [lindex $patchRec 10]
        #    if {"$module"==""} {
        #        puts "$patchRec does not contain module name. Skipping it."
        #        continue
        #    }
        #    
        #    if [catch {exec $g(RCP) $otherip:$g(backupDir)/${module}_${patchStr}  $g(backupDir)} result] {
        #            puts " $g(RCP) $otherip:$g(backupDir)/${module}_${patchStr}  $g(backupDir)  failed"
        #           puts "$result"
        #            return 0
        #        }
        #}
    }
    SaveAdminData $g(backupAdminFile)
    return 1
}
# ===============================================================================

    global g patchAdmin
    catch {ExecuteCmd "$g(MKDIR) -p -m 777  $g(backupDir)"}
    
    Synch

    if [file readable $g(backupAdminFile)] {
        if [catch {source $g(backupAdminFile)} result] {
            OutputError "$result"
            exit 1
        }
    }



# set g(userName)  [GetPrompt "User name"  30 $g(userName)  VerifyUserName]

    if {"$argc" == "0" } {
        PrintTitleScreen Wss "Patch Tool"
        ViewLog
        set g(noninteractive) 0
    # Interactive Invocation
        while {1} {
          set command [GetPrompt "Command (patch/view/modify/delete/history/apply/quit)?" 40 view VerifyUserSelectCommand]
            set command [string range $command 0 0]
            switch -regexp -- $command {
                {v[^ ]*} {
		    puts "To see ACTIVE patches, enter 'ACTIVE' for 'Status:'" 
                    set module  [GetPrompt "Module Name"  30 "" ""]
                    set status  [GetPrompt "Status"  30 "" ""]
		    set card [GetPrompt "Card Type"  30 "" ""]
                    ViewLog $module $status $card
                    }

                
                {p[^ ]*} {
		    set check no
                    set username  [GetPrompt "User name" 30 ""  VerifyUserName]
                    set module  [GetPrompt "Module Name"  30 "" ""]
                    set version [GetPrompt "Version" 30 ""  ""  ]
		    set desc    [GetPrompt "Description" 30 ""  "" ]
                    set cardtype [GetPrompt "Card Type" 30 ""  VerifyCardType]
                    set status  [GetPrompt "Status" 30 "REGISTER"  VerifyStatus]
                    if {[info exists srcfile]} {
                        set newDirName [file dirname $srcfile]
                        set srcfile $newDirName/$module
                        set srcfile [GetPrompt "Source file"     30 $srcfile VerifyFileReadable]
                    } else {
                        set srcfile [GetPrompt "Source file"     30 "" VerifyFileReadable]
                    }
                    set l [string length $module ] 
                    set ll [expr $l - 3 ]
                    set ext [string range $module $ll end]
		    
                    if {[string compare $ext  "ems"] == 0 || [string compare  $ext "jar"] == 0} {
                        set destdir [GetPrompt "Target directory" 30 "/space/Spatial/ems/active/patch/" VerifyDirectoryWritable]
                    } elseif {[string compare  $ext "bin"] == 0} {
		      set check yes
		      if [catch {cd /space/Spatial/msc/} result] {
                        puts "$result"     
			puts "Cannot determine active build as /space/Spatial/msc/ does not exists; Hence cannot apply MSF patches"
		      } else {
		      	    set var1 [exec ls -l | egrep {active}]
		      	    set var2 [lindex $var1 10]
			    # set counter 0	       
                            set my_destdir [GetPrompt "Target directory" 30 "/space/Spatial/msf/*/$var2/BIN/" ""]
			    if ![catch {set dirlist [glob $my_destdir]} result] {
			       foreach my_list $dirlist {
			        catch {regexp {[^msf\/]*msf\/([^\/]*)\/*} $my_list var10 var11}
			      # incr counter
			         VerifyDirectoryWritable $my_list
			         set destdir $my_list 
			         set patchId [PatchFile $username $module$var11 $version $desc $cardtype $status $srcfile $destdir "0" "0"]
		                 if { "$patchId"!=0 } {
                      		    if  { "$status"=="REGISTER" } {
                         	      puts "Assigned patchId = $patchId. Request queued for later application."
                      	            } else {
                          	      puts "Assigned patchId = $patchId."
                      	            }
		                  } 
			        }  
		            }
		     }	 
		    } else { 
                        set destdir [GetPrompt "Target directory" 30 "/space/Spatial/msc/active/patch/" VerifyDirectoryWritable]
                    }
                    
		    if {"$check" != "yes"} {
		     set patchId [PatchFile $username $module $version $desc $cardtype $status $srcfile $destdir ]
		     if { "$patchId"!=0 } {
                      if  { "$status"=="REGISTER" } {
                         puts "Assigned patchId = $patchId. Request queued for later application."
                      } else {
                          puts "Assigned patchId = $patchId."
                      }
		     } 
		    } 
	       } 

                {m[^ ]*} {ModifyFile} 
	 	{d[^ ]*} {DeletePatch}
                {h[^ ]*} {
                    set module  [GetPrompt "Module Name"  30 "" ""]
                    HistoryLog $module
                 }
                {a[^ ]*} {ApplyPatch "1" "0" "0" "1" ""}
                {q[^ ]*} {break}
            }
        }
    } else {
        set g(noninteractive) 1
        set command [lindex $argv 0]
#    puts stdout $command
        switch -regexp -- $command {
            {-v[^ ]*} {
                if { $argc < 2 } {
					set module ""
					set status ""
					set card ""
					set view_filename ""
                } elseif {$argc < 3} {
					set status ""
					set card ""
					set view_filename ""
                } elseif {$argc < 4} {
					set card ""
					set view_filename ""
				} elseif {$argc < 5} {
					set view_filename ""
				}

                set module [lindex $argv 1]
                set status [lindex $argv 2]
				set card [lindex $argv 3]
				set view_filename [lindex $argv 4]

				if {$card != ""} {
					if ![VerifyCardType $card] { 
						puts "Usage swpatch -view   <module> <status> <card type> [file name]
						Example1: swpatch -view  BsPm \"\" sim  
						Example2: swpatch -view  \"\"  \"\" sim" 
						exit
					}
				}
				if ![VerifyStatus $status] {
					puts "status can only be specified as REGISTER or ACTIVE or INACTIVE"
					exit
				}
   				#if {"$status"!="ACTIVE" &&  "$status"!=""} {
     			#	puts "status can only be specified as ACTIVE."
 				#	puts "Usage swpatch -view   <module> <status> <card type> 
				#	Example1: swpatch -view  BsPm \"\" sim
				#	Example2: swpatch -view  \"\"  \"\" sam" 
				#	exit
   				#}
				ViewLog  $module $status $card $view_filename
 	        }
            {-p[^ ]*} {
                set username  [lindex $argv 1]
                set module    [lindex $argv 2]
                set version   [lindex $argv 3]
                
                set status    [lindex $argv 6]
                if ![VerifyStatus $status] {
                    exit 
                }

				set srcfile    [lindex $argv 7]
				if { "$status"!="ACTIVE" } {
					if ![VerifyFileReadable $srcfile] {
						exit
					}
				}                
                set destdir      [lindex $argv 8]
                if ![VerifyDirectoryWritable $destdir] {
                    exit
                }
                set desc      [lindex $argv 4]
                set cardtype  [lindex $argv 5]
#                #if ![VerifyCardType $cardtype] {
#                #    exit 
#                #}
				
				set copyonly [lindex $argv 9]
				set execute [lindex $argv 10]

				foreach cardnum [split $cardtype ,] {
					set patchId [PatchFile $username $module $version $desc $cardnum $status $srcfile $destdir $copyonly $execute]
					
					if { "$patchId"!=0 } {
						if  { "$status"=="REGISTER" } {
							puts "Assigned patchId = $patchId. Request queued for later application."
						} else {
						puts "Assigned patchId = $patchId."
						}
					}
				}
            }
            {-m[^ ]*} {
                set patchid [lindex $argv 1]
                ModifyFile $patchid
            }
			
            {-d[^ ]*} {
                if { $argc < 2 } {
					set module ""
					set status ""
					set card ""
					set view_filename ""
                } elseif {$argc < 3} {
					set status ""
					set card ""
					set view_filename ""
                } elseif {$argc < 4} {
					set card ""
					set view_filename ""
				} elseif {$argc < 5} {
					set view_filename ""
				}
                set module [lindex $argv 1]
                set status [lindex $argv 2]
				set card [lindex $argv 3]
				set view_filename [lindex $argv 4]

                if {$card != ""} {
					if ![VerifyCardType $card] { 
						puts "Usage swpatch -delete   <module> <status> <card type> [file name]
						Example1: swpatch -delete  BsPm \"\" sim  
						Example2: swpatch -delete  \"\"  \"\" sim" 
						exit
					}
				}
				if ![VerifyStatus $status] {
					puts "status can only be specified as REGISTER or ACTIVE or INACTIVE"
					exit
				}
				DeleteLog  $module $status $card $view_filename
                #set patchid [lindex $argv 1]
                #DeletePatch $patchid
            }

            {-h[^ ]*} {
                if { $argc < 2 } {
                   set module ""
                } else {
                  set module [lindex $argv 1]
                }
                HistoryLog $module
            }

            {-a[^ ]*} {
       			set option_n [lindex $argv 1]
				set option_g [lindex $argv 2]
				set option_l [lindex $argv 3]
				set option_e [lindex $argv 4]
				set option_skip [lindex $argv 5]
				set tmp [lindex $argv 6]
				set g(out_of_service) 0
				if {"$tmp"=="OUT_OF_SERVICE"} { set g(out_of_service) 1 }
				#puts "swpatch.tcl:apply:non-interactive: option_n = $option_n, option_g = $option_g, option_l = $option_l, option_skip = $option_skip, outofservice = $g(out_of_service), tmp = $tmp"
				ApplyPatch $option_n $option_g $option_l $option_e $option_skip

            }

            {default} {puts "Usage: Interactive: swpatch.tcl 
       Non-interactive:
swpatch -view   <module> <status> <card type> 
swpatch -patch  <username> <module> <version> <desc> <cardtype> <status> <srcfile> <destdir>
swpatch -modify <patchid>
swpatch -delete <patchid>
swpatch -history   <module> 
swpatch -apply

The command line arguments can be abbreviated.
For interactive invocation please do not specify any arguments.
Specify complete paths for srcfile and dest arguments.
Dest argument should be just the directory path.
For modify operation specify a patchid list from the displayed list."
            }
        }
    }
    catch {close $g(logFileFd)}
    exit
