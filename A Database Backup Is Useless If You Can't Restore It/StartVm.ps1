# start vm

$Subscription = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
$RgName = "rg-" # resource group
$VmName = "vmd"  # vm name

# Ensures you do not inherit an AzContext in your runbook
Disable-AzContextAutosave -Scope Process

# Connect to Azure with system-assigned managed identity
$AzureContext = (Connect-AzAccount -Identity).context

# Set context
Set-AzContext -Subscription $Subscription

# Start VM
Start-AzVM -Name $VmName -ResourceGroupName $RgName
