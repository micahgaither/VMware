###############################################
#Connecting to ESX Server 
###############################################
add-pssnapin vm*
Connect-VIServer "##vcenter##" -user "##user###" -password "##password##"
###############################################
# Identify Excel Workbook and Work Sheet
###############################################
$ExcelSourceFile = "C:\Users\user\OneDrive\Documents\file.xlsm"
$SheetName = "Virtual Machines"
$targetWbName = Split-Path $ExcelSourceFile -Leaf
$xl = [Runtime.Interopservices.Marshal]::GetActiveObject('Excel.Application')    # get the list of open workbooks
$Excelworkbook = $xl.Workbooks.Item($targetWbName)                               # Get Workbook
$ExcelWorkSheet = $ExcelWorkbook.Worksheets.Item($SheetName)                     # get the Work sheet
$range = $ExcelWorkSheet.Range("A2","H2000")                                     # Select the Range of Cells containing Data
$range.clear()                                                                   # Clear Cell range of Data
#############################################################
#Get all VM Names That are powered On and all ESX host names
#############################################################
$VMHosts=get-view -ViewType hostsystem -Property name,parent
$VMs = get-view -ViewType virtualmachine -Property name,runtime.host,runtime.powerstate,summary.config.numcpu,summary.config.memorysizemb,guest.guestfullname,guest.ipaddress -Filter @{'Runtime.PowerState'='PoweredOn'}
$hostshash=@{}
$VMHosts|%{$hostshash.Add($_.moref.toString(),$_.name)}
########################################################
#Write Inventory Data to excel
########################################################$VMs.Count+1
For ($Row=2; $Row -le $VMs.Count+1; $Row++){
    Write-Progress -Activity "Updating Virtual machine Inventory" -status "Rows Updated $Row" ` -percentComplete (($Row / ($Vms.count+1))*100)
    $VM=$VMs[$Row-1]|select name,@{n='HostSystem';e={$hostshash.($_.Runtime.Host.ToString())}}
    $VMHost = $VM.Hostsystem
    $VMNAME = $VM.Name
    $CPU = $VMs[$row-1].Summary.Config.NumCpu
    $RAM = $VMs[$Row-1].Summary.config.MemorySizeMB
    $SiteID = "$VMhost".Substring(2,5)
    $PowerState = $VMs[$Row-1].runtime.powerstate
    $OS = $VMs[$Row-1].guest.guestfullname
    $IPAddress = $VMs[$row-1].guest.ipaddress
    $ExcelWorkSheet.Cells.Item("$Row",1) = "$VMName"
    $ExcelWorksheet.Cells.Item("$Row",2) = "$OS"
    $ExcelWorksheet.Cells.Item("$Row",3) = "$IPAddress"
    $ExcelWorkSheet.Cells.Item("$Row",4) = "$PowerState"
    $ExcelWorkSheet.Cells.Item("$Row",5) = "$VMHost"
    $ExcelWorkSheet.Cells.Item("$Row",6) = "$SiteID"
    $ExcelWorkSheet.Cells.Item("$Row",7) = "$RAM"
    $ExcelWorkSheet.Cells.Item("$Row",8) = "$CPU"} 
###############################################
# Save Changes
###############################################
$Excelworkbook.Save()                                                              #Save Workbook