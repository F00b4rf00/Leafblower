# Leafblower
Powershell script to make room for compressed plots by removing Chia OG plots from mounted hard drives.

The script makes room for compressed Chia plots by maintaining free space on drives by deleting full-sized OG plots when the disk is getting full. Let it run in the background and leafblow the old plots away from the drive.

In the script file cofnigure the following:

$mountDirectory = "C:\mount" # Replace with the directory where the drives are mounted
$minFreeSpace = 180 # The minimum amount of free space, in GB, that you want to keep per drive for compressed plots (e.g. if moving compressed plots one by one, at least the size of one compressed plot)
$minFileSize = 90 # The minimum file size, in GB, that you want to delete (greater than the size of a compressed plot and less than OG plot
$cleanFreq = 600 # recheck frequency in seconds
