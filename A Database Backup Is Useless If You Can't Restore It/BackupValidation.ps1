<#
Script name: TestRestores.ps1
https://docs.dbatools.io/Test-DbaLastBackup
modules required: dbatools
#>

$Destination = "WIN-K2NV3D17HHC"
$WorkDir = "C:\BackupValidation"
$OutFile = "$WorkDir\BackupValidation.csv"
$LogFile = "$WorkDir\Logfile.txt"
$PSEmailServer = 'smtp.mymailserver.com'
$SqlServers = Get-Content "$WorkDir\servers.txt" | Sort-Object # ordered list of sql server names in text file

# cd to working directory
Set-Location $WorkDir

# delete old outfiles
If (Test-Path "$OutFile"){Remove-Item "$OutFile"}

# trap errors/warnings in log file
Start-Transcript -Path $Logfile

# Test-DbaLastBackup 
Test-DbaLastBackup -SqlInstance $SqlServer -Destination $Destination | `
Select-Object SourceServer,Database,FileExists,Size,RestoreResult,RestoreElapsed,DbccResult, `
              # https://www.millersystems.com/powershell-exporting-multi-valued-attributes-via-export-csv-cmdlet/
              @{Name='BackupFiles';Expression={[string]::join("`n", ($_.BackupFiles))}} | `
Export-Csv -Path $OutFile -Append -NoTypeInformation

# stop logging
Stop-Transcript 

# email attachemts
$Attachments = @("$OutFile","$LogFile")
Send-MailMessage -To "dba@mycompany.com" -From "testrestores@mycompany.com" -Subject "Test Restores Report" -Attachments $Attachments
