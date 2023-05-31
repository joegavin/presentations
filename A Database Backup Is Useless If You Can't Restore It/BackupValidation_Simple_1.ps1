$SqlInstance = "WIN-K2NV3D17HHC"
$Destination = "WIN-K2NV3D17HHC"

Test-DbaLastBackup -SqlInstance $SqlInstance -Destination $Destination | Select-Object * | Format-Table