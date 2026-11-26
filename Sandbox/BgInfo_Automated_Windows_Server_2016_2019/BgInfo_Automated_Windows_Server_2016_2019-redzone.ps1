<#
.SYNOPSIS
 
A script used to download, install and configure the latest BgInfo version on a Windows Server 2016 or 2019.
 
.DESCRIPTION
 
A script used to download, install and configure the latest BgInfo version (v4.27) on a Windows Server 2016 or 2019. The BgInfo folder will be created on the C: drive if the folder does not already exist. 
Then the latest BgInfo.zip file will be downloaded and extracted in the BgInfo folder. The LogonBgi.zip file which holds the preferred settings will also be downloaded and extracted to the BgInfo folder. 
After extraction both .zip files will be deleted. A registry key (regkey) to AutoStart the BgInfo tool in combination with the logon.bgi config file will be created. At the end of the script BgInfo will 
be started for the first time and the PowerShell window will be closed.
 
.NOTES

Adapted from a script by Wim Matthyssen for ThermoFisher Scientific by Ron Gines.
Original script can be found at https://tinyurl.com/y3wmsh7o

 
File Name:         BgInfo_Automated_Windows_Server_2016_2019-redzone.ps1
Created:           08/09/2019 - Original By Wim Matthyssen
Adapted:	   02/19/2021 
Last modified:     04/07/2021 
Author:            Ron Gines
PowerShell:        5.1 or above 
Requires:          -RunAsAdministrator
OS:                Windows Server 2016 and Windows Server 2019
TFS-MSE Version:   1.1
Action:            Change variables were needed to fit your needs
Disclaimer:        This script is provided "As Is" with no warranties.
 
.EXAMPLE
 
.\BgInfo_Automated_Windows_Server_2016_2019-redzone.ps1

#>
 
## Variables (These may need to be changed)
$bgInfoFolder           = "C:\BgInfo"
## $bgInfoUrl           = "https://download.sysinternals.com/files/BGInfo.zip"  # Original Source
$bgInfoUrl              = "\\usslo-mpn-NAS01.thermo.com\MSE-Equipment-SW\BgInfo\BGInfo.zip"
## $logonBgiUrl            = "https://tinyurl.com/yxlxbgun"                     # Original Source
$logonBgiUrl            = "\\usslo-mpn-NAS01.thermo.com\MSE-Equipment-SW\BgInfo\logonbgi-1.zip"

## Variables (These should not need to be changed)
$bgInfoFolderContent    = $bgInfoFolder + "\*"
$itemType               = "Directory"
$bgInfoZip              = "$BgInfoFolder\BGInfo.zip"
$bgInfoEula             = "$BgInfoFolder\Eula.txt"
$logonBgiZip            = "$BgInfoFolder\LogonBgi.zip"
$bgInfoRegPath          = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
$bgInfoRegKey           = "BgInfo"
$bgInfoRegType          = "String"
$bgInfoRegKeyValue      = "$BgInfoFolder\Bginfo64.exe $BgInfoFolder\logon.bgi /timer:0 /nolicprompt"
$regKeyExists           = (Get-Item $bgInfoRegPath -EA Ignore).Property -contains $bgInfoRegkey
$writeEmptyLine         = "`n"
$writeSeperator         = " - "
$time                   = Get-Date -UFormat "%A %m/%d/%Y %R"
$foregroundColor1       = "Yellow"
$foregroundColor2       = "Red"
 
##-------------------------------------------------------------------------------------------------------------------------------------------------------
 
## Make sure we have access to the installation files

If (!(Test-Path -Path $bgInfoUrl )){
   Write-Host "We don't seem to have access to the following folder!"
   Write-Host $bgInfoUrl 
   Write-Host "Check that this directory is accessible from this computer and ID."
   Write-Host "We are ending the script here."
   exit
   }

If (!(Test-Path -Path $logonBgiUrl )){
   Write-Host "We don't seem to have access to the following folder!"
   Write-Host $bgInfoUrl 
   Write-Host "Check that this directory is accessible from this computer and ID."
   Write-Host "We are ending the script here."
   exit
   }


##-------------------------------------------------------------------------------------------------------------------------------------------------------
 
## Write Download started
 
Write-Host ($writeEmptyLine + "# BgInfo download started" + $writeSeperator + $time)`
-foregroundcolor $foregroundColor1 $writeEmptyLine
 
##-------------------------------------------------------------------------------------------------------------------------------------------------------
 
## Create BgInfo folder on C: if not exists, else delete its content
 
If (!(Test-Path -Path $bgInfoFolder)){New-Item -ItemType $itemType -Force -Path $bgInfoFolder
   Write-Host ($writeEmptyLine + "# BgInfo folder created" + $writeSeperator + $time)`
   -foregroundcolor $foregroundColor1 $writeEmptyLine
}Else{Write-Host ($writeEmptyLine + "# BgInfo folder already exists" + $writeSeperator + $time)`
   -foregroundcolor $foregroundColor2 $writeEmptyLine
   Remove-Item $bgInfoFolderContent -Force -Recurse -ErrorAction SilentlyContinue
   Write-Host ($writeEmptyLine + "# Content existing BgInfo folder deleted" + $writeSeperator + $time)`
   -foregroundcolor $foregroundColor2 $writeEmptyLine}
 
 ##-------------------------------------------------------------------------------------------------------------------------------------------------------
 
## Download, save and extract latest BGInfo software to C:\BgInfo
 
## For the RedZone we will copy from a local repository
## Import-Module BitsTransfer
## Start-BitsTransfer -Source $bgInfoUrl -Destination $bgInfoZip
copy-item -Path $bgInfoUrl  -Destination $bgInfoZip
Expand-Archive -LiteralPath $bgInfoZip -DestinationPath $bgInfoFolder -Force
Remove-Item $bgInfoZip
Remove-Item $bgInfoEula
Write-Host ($writeEmptyLine + "# bginfo.exe available" + $writeSeperator + $time)`
-foregroundcolor $foregroundColor1 $writeEmptyLine
 
##-------------------------------------------------------------------------------------------------------------------------------------------------------
 
## Download, save and extract logon.bgi file to C:\BgInfo
 
# Invoke-WebRequest -Uri $logonBgiUrl -OutFile $logonBgiZip
copy-item -Path $logonBgiUrl  -Destination $logonBgiZip
Expand-Archive -LiteralPath $logonBgiZip -DestinationPath $bgInfoFolder -Force
Remove-Item $logonBgiZip
Write-Host ($writeEmptyLine + "# logon.bgi available" + $writeSeperator + $time)`
-foregroundcolor $foregroundColor1 $writeEmptyLine
 
##-------------------------------------------------------------------------------------------------------------------------------------------------------
 
## Create BgInfo Registry Key to AutoStart
 
If ($regKeyExists -eq $True){Write-Host ($writeEmptyLine + "BgInfo regkey exists, script wil go on" + $writeSeperator + $time)`
-foregroundcolor $foregroundColor2 $writeEmptyLine
}Else{
New-ItemProperty -Path $bgInfoRegPath -Name $bgInfoRegkey -PropertyType $bgInfoRegType -Value $bgInfoRegkeyValue
Write-Host ($writeEmptyLine + "# BgInfo regkey added" + $writeSeperator + $time)`
-foregroundcolor $foregroundColor1 $writeEmptyLine}
 
##-------------------------------------------------------------------------------------------------------------------------------------------------------
 
## Run BgInfo
 
C:\BgInfo\Bginfo64.exe C:\BgInfo\logon.bgi /timer:0 /nolicprompt
Write-Host ($writeEmptyLine + "# BgInfo has ran for the first time" + $writeSeperator + $time)`
-foregroundcolor $foregroundColor1 $writeEmptyLine
 
##-------------------------------------------------------------------------------------------------------------------------------------------------------
 
## Exit PowerShell window 2 seconds after completion
 
Write-Host ($writeEmptyLine + "# Script completed, the PowerShell window will close in 2 seconds" + $writeSeperator + $time)`
-foregroundcolor $foregroundColor2 $writeEmptyLine
Start-Sleep 2 
stop-process -Id $PID
 
##-------------------------------------------------------------------------------------------------------------------------------------------------------