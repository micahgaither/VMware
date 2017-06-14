$vcserver = "#vcenter#"
Add-PSsnapin VMware.VimAutomation.Core
Get-Cluster "#cluster#" | Get-VMHost | Foreach {
Start-VMHostService -HostService ($_ | Get-VMHostService | Where { $_.Key -eq "TSM-SSH"} )
} 