/* REXX *****/
/* trace ?r */
/*
Oculus Browser v#BUILD_NUMBER#
=====================

Build #BUILD_NUMBER#, MBI: #MBI#, is complete and available on the Oculus Moonlight Staging channel:

https://our.intern.facebook.com/intern/mobile/releases/history?app_id=525967784198252&channel=1410509132601072

The build APK and the lib.unstripped bits, along with the Sandcastle processed APK are on Dropbox:

https://www.dropbox.com/sh/bdsgk6ghn93ybgu/AAD34hi2qiG9yzUB-PJ4n5Ida?dl=0

On the Store, the build is available on the #CHANNEL# channel:

https://dashboard.oculus.com/application/1257988667656584/build

The following updates/fixes are included:

*/

parse arg argv

sysut1 = "sysut1"
sysut2 = "sysut2"

build_n = "3.6.4"
build_i = "999999999"
channel = "Alpha"

call charout ,"build: "
pull build_n

call charout ,"MBI: "
pull build_i

call charout ,"channel: "
pull channel

if stream(sysut1, C, "QUERY EXISTS") <> "" then do
  address cmd "del /F" sysut1 ">nul 2>&1"
  end

if stream(sysut2, C, "QUERY EXISTS") <> "" then do
  address cmd "del /F" sysut2 ">nul 2>&1"
  end

do index=4 to 20
  call lineout sysut1, sourceline(index)
  end

call lineout sysut1

sed = "sed.exe"

sed_list.0 = 3
sed_list.1 = "-e s/#BUILD_NUMBER#/" || build_n || "/"
sed_list.2 = "-e s/#MBI#/" || build_i || "/"
sed_list.3 = "-e s/#CHANNEL#/" || channel || "/"

sed_args = ""
do index=1 to sed_list.0
  sed_args = sed_args sed_list.index
  end

address cmd sed sed_args sysut1 ">>"sysut2

if stream(sysut1, C, "QUERY EXISTS") <> "" then do
  address cmd "del /F" sysut1 ">nul 2>&1"
  end

say "Enter fixes, one per line. End input with single '.'"

fix = ""
do FOREVER
  pull fix
  if fix == "." then do
    leave
    end

  call lineout sysut2, fix
  end

call lineout sysut2

/*
T20275372 - Capture/record during 3D video causes frame offset fix.

https://our.intern.facebook.com/intern/tasks/?t=20275372
*/

return
