# This script makes room for compressed Chia plots by maintaining free space on drives by deleting full-sized OG plots when the disk is getting full. Let it run in the background and leafblow the old plots away from the drive.,

$mountDirectory = "C:\mount" # Replace with the directory where the drives are mounted
$minFreeSpace = 180 # The minimum amount of free space, in GB, that you want to keep per drive for compressed plots (e.g. if moving compressed plots one by one, at least the size of one compressed plot)
$minFileSize = 90 # The minimum file size, in GB, that you want to delete (greater than the size of a compressed plot and less than OG plot
$cleanFreq = 600 # recheck frequency in seconds

while ($true) {
    Write-Output "Scanning drive free space"
    $drives = Get-WmiObject Win32_Volume | Where-Object { $_.Name -like "$($mountDirectory)*" }
    foreach ($drive in $drives) {
        ##$driveInfo = Get-Volume -DriveLetter $drive.Name
        ##$driveInfo = Get-Volume -Path $drive.__PATH

        $freeSpace = $drive.FreeSpace / 1GB
        Write-Output "Drive $($drive.name) Free Space $($freeSpace)"

        if ($freeSpace -lt $minFreeSpace) {
            $filesToDelete = Get-ChildItem -Path "$($drive.Name)" -Recurse -File | Where-Object { $_.Length -gt ($minFileSize * 1GB) }
            if ($filesToDelete) {
                foreach ($file in $filesToDelete) {
                    Write-Output "Deleting $($file.FullName) for $($file.Length / 1GB) ..."
                    Remove-Item -Path $file.FullName -Force
                    $freeSpace += $file.Length / 1GB
                    if ($freeSpace -ge $minFreeSpace) {
                        break
                    }
                    Start-Sleep -Seconds 1 # Wait 1 sec before deleting next file. This is to avoid catasthrophic deletion of full drive contents in an instant. When in operation, this causes minor delays betweend deletions and can be removed.
                }
            }
        }
    }
    Start-Sleep -Seconds $cleanFreq # Wait 10 minutes before checking again
}
