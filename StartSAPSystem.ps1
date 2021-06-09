# Connect to Azure using the Azure Service Principal connection AzureRunAsConnection
$Conn = Get-AutomationConnection -Name AzureRunAsConnection
Connect-AzAccount -ServicePrincipal -Tenant $Conn.TenantID -ApplicationId $Conn.ApplicationID -CertificateThumbprint $Conn.CertificateThumbprint

# Force the use of subscription GROUP - GF&SU FIT SAP POC
$AzureSubscriptionId = '3a39d011-4a07-4b7b-87ae-484161cf08ae'
Select-AzSubscription -SubscriptionId $AzureSubscriptionId

# Name of the resource group that contains the VM
$rgName = 'NE-SAP-TEM-TS1-RG'

# Name of the virtual machine
$vmName = 'NE-SAP-TEM-TS2-VM-SAP'

# Container where the script is located
$ContainerName  = 'scripts'

# Script to execute in the VM - script starting SAP System
$localmachineScript = 'StartSAPSystem.ps1'

# Create a context based on the specified connection string for the storage account nesaptemts1sto
$StorageContext = New-AzStorageContext -ConnectionString "DefaultEndpointsProtocol=https;AccountName=nesaptemts1sto;AccountKey=WiDXQrXPK1G1FLmYiSXrHeGULNO8KPFXWn/87O6wyTduiSnQXYN0fq6LL2//zjGoV325KRNjwurEp+nICZfF8A==;EndpointSuffix=core.windows.net"

# Get the script and store it in $env:temp
Get-AzStorageBlobContent -Container $ContainerName -Blob $localmachineScript -Context $StorageContext -Destination $env:temp -Force

#Execute the script in the VM
Invoke-AzVMRunCommand -ResourceGroupName $rgname -Name $vmname -CommandId 'RunShellScript' -ScriptPath "$env:temp\$localmachineScript"
