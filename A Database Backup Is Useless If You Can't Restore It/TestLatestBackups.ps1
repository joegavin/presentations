<#
Script name: TestLatestBackups.ps1
https://docs.dbatools.io/Test-DbaLastBackup
modules required: dbatools, ImportExcel
#>

# begin set vars
$Destination = "WIN-GV2FHVT9S4A"            # SQL Server you're restoring to
$WorkDir = 'D:\Scripts\TestLatestBackups'   # work directory
$OutFile = 'TestLatestBackups.xlsx'         # output file name
$LogFile = "$WorkDir\TestLatestBackups.txt" # transcript log file
$WorksheetName = "TestLatestBackups"        # Excel spreadsheet worksheet name
$TableName = "TestLatestBackups"            # Excel spreadsheet table name
$TableStyle = "Medium14"                    # Excel spreadsheet table style 
$PSEmailServer = 'smtp.domain.ext'          # email server name
$To = "dbagroup@domain.ext"                 # email to
$From = "$env:COMPUTERNAME@domain.ext"      # email from 
$Subject = "TestLatestBackups Report"       # email subject
# end set vars

# build ordered list of sql servers from file
$SqlServers = Get-Content "$WorkDir\servers.txt" | Sort-Object

# cd to working directory
Set-Location $WorkDir

# delete old outfile
If (Test-Path "$OutFile"){Remove-Item "$OutFile"}

# trap errors/warnings in log file
Start-Transcript -Path $Logfile

Set-DbatoolsInsecureConnection

# Test-DbaLastBackup 
$Results = Test-DbaLastBackup -SqlInstance $SqlServers -Destination $Destination | `
Select-Object SourceServer,Database,FileExists,Size,RestoreElapsed,RestoreResult,DbccResult, `
              # https://www.millersystems.com/powershell-exporting-multi-valued-attributes-via-export-csv-cmdlet/
              @{Name='BackupDates';Expression={[string]::join("`n", ($_.BackupDates))}}, ` 
              @{Name='BackupFiles';Expression={[string]::join("`n", ($_.BackupFiles))}} 

$Results | Export-Excel -Path $OutFile -WorksheetName $WorksheetName -AutoSize -MaxAutoSizeRows 0 -AutoFilter -BoldTopRow -TableName $TableName -TableStyle $TableStyle  

# stop logging
Stop-Transcript 

# email attachemts
$Attachments = @("$OutFile","$LogFile")
Send-MailMessage -To $To -From $From -Subject $Subject -Attachments $Attachments -Credential $Credential
