$vcserver = "#vcenter#"
Add-PSsnapin VMware.VimAutomation.Core
Connect-VIServer $vcserver
Get-Cluster "#cluster#" | Get-VMHost | Get-VMHostService | Where { $_.Key -eq "TSM-SSH" } |select VMHost, Label, Running