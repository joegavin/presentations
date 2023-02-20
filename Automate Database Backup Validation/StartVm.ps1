# start vm

$ServicePrincipalConnection = Get-AutomationConnection -Name 'AzureRunAsConnection' # get connection
Add-AzAccount -ServicePrincipal -TenantId $ServicePrincipalConnection.TenantId -ApplicationId $ServicePrincipalConnection.ApplicationId `
-CertificateThumbprint $ServicePrincipalConnection.CertificateThumbprint
$RgName ="rg-name" # resource group
$VmName ="vmname"  # vm name

# Start VM
Start-AzVM -Name $VmName -ResourceGroupName $RgName
