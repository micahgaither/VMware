$vcserver = "#vcenter#"
Add-PSsnapin VMware.VimAutomation.Core
Connect-VIServer $vcserver
Get-Cluster "#cluster#" | Get-VMHost | Get-AdvancedSetting -Name 'UserVars.ESXiShellInteractiveTimeOut' | Set-AdvancedSetting -Value "0" -Confirm:$false
Get-Cluster "#cluster#" | Get-VMHost | Get-AdvancedSetting -Name 'UserVars.ESXiShellTimeOut' | Set-AdvancedSetting -Value "0" -Confirm:$false
Get-Cluster "#cluster#" | Get-VMHost | Get-AdvancedSetting -Name 'UserVars.SuppressShellWarning' | Set-AdvancedSetting -Value "1" -Confirm:$false
