

##################################################################################################################################################
# Sourced from file named:
#       .\TFS-MSE-AutomationInfrastructure\MSEAutomation\Code\Functions\Logging\Add-MSEEventLogSource.ps1
##################################################################################################################################################
#################################################################################################################################################
# Function Add-MSEEventLogSource                                                                                        
#################################################################################################################################################
<# 
 .SYNOPSIS 
	 This function will set up an Event source in the local Windows Event Logs called "MSE-Scripts"

 .DESCRIPTION 
	 This function will set up an Event source in the local Windows Event Logs called "MSE-Scripts".   
     This will allow us to make calls from our scripts that will record specific events and errors 
     into the event log that can be searched under this source name.   This will be in addition to 
     the PowerShell event loggin whcih will be turned on for each Windows System.   This will allow
     for our own event messages to be placed in the Windows Event Log.

 .NOTES 
     Author       : 	 Ron Gines
     Date         :      1/15/2016
     Version Date : 	 Version 1.0 - Original scritp by Ron Gines.  Added to the Infrastructure Functions.

     


 .EXAMPLE   
	 Add-MSEEventLogSource
#> 
Function Add-MSEEventLogSource 
{
  $FunctionName = "Add-MSEEventLogSource"
  Log-MSEWrite $ScriptLogFullName "$($FunctionName): -------------------------------------" $false
  Log-MSEWrite $ScriptLogFullName "$($FunctionName): >>>>>Loading" $false

   if ([System.Diagnostics.EventLog]::SourceExists("MSE-Scripts"))
   {
      Log-MSEWrite $ScriptLogFullName "'MSE-Scripts' already exists as an Event Log Source on this system." $true
   }
   else
   {
      Try
      {
         New-EventLog -LogName Application -Source "MSE-Scripts"
         Log-MSEWrite $ScriptLogFullName "'MSE-Scripts' was successfully added as an Event Log Source on this system." $true
      }
      Catch
      {
         Log-MSEWrite $ScriptLogFullName "'MSE-Scripts' was successfully added as an Event Log Source on this system." $true
         Log-MSEWrite $ScriptLogFullName "$($FunctionName): User Creation function for $($NewUserID) Failed." $true
         Log-MSEWrite $ScriptLogFullName "$($FunctionName): Error Message: $_.Exception.Message" $true
         Log-MSEWrite $ScriptLogFullName "$($FunctionName): Filed Item   : $_.Exception.ItemName " $true
      }
   }

#  Example:
#  Write-EventLog -Logname Application -Source "MSE-Scripts" -EntryType Information 1 -Message "VersionChecks: Script VersionCheck is starting."

} # End Function Add-MSEEventLogSource

##################################################################################################################################################
# Sourced from file named:
#       .\TFS-MSE-AutomationInfrastructure\MSEAutomation\Code\Functions\Logging\Close-MSELogFile.ps1
##################################################################################################################################################
#################################################################################################################################################
# Function Close-MSELogFile
#################################################################################################################################################
<# 
 .SYNOPSIS 
	 This function will close down the log file for us.

 .DESCRIPTION 
	 This function will close down the log file for us.

 .NOTES 
     Author       : 	 Ron Gines
     Date         :      1/15/2016
     Version Date : 	 Version 1.0 - Added to the Infrastructure Functions

     Author       : 	 Ron Gines
     Date         :      04/15/2021
     Version Date : 	 Version 1.1 - Rewritten for the MSEAutomation Infrastructure Functions

 .EXAMPLE   
	 Close-MSELogFile
#> 
Function Close-MSELogFile
{
  [CmdletBinding(SupportsShouldProcess=$True)]
  Param ([Parameter(Mandatory=$true,Position=0)][string]$LogPath
  ) # End Param

  # Clean up variables and define in-house variables
  $FunctionName = "Write-MSELogFile"

  If (!(Test-Path -Path $LogPath)){
     (Add-Content -Path $LogPath -Value "***************************************************************************************************")
     (Add-Content -Path $LogPath -Value "Started processing at [$([DateTime]::Now)].")
     (Add-Content -Path $LogPath -Value "***************************************************************************************************")
  }
   $FunctionName = "Log-WrapUp"
   Write-MSELogFile $LogPath "$($FunctionName): -------------------------------------" $false
   Write-MSELogFile $LogPath "$($FunctionName): >>>>>Entering" $false

   Write-MSELogFile $LogPath "####################################" $true
   (Add-Content -Path $LogPath -Value "***************************************************************************************************")
   (Add-Content -Path $LogPath -Value "Finished processing at [$([DateTime]::Now)].")
   (Add-Content -Path $LogPath -Value "***************************************************************************************************")
   Write-MSELogFile $LogPath "We should be done with the script.   This should be the last formal entry." $true

   Write-MSELogFile $LogPath "$($FunctionName): <<<<<Exiting" $false
   Write-MSELogFile $LogPath "$($FunctionName): -------------------------------------" $false
} # End Function Close-MSELogFile

##################################################################################################################################################
# Sourced from file named:
#       .\TFS-MSE-AutomationInfrastructure\MSEAutomation\Code\Functions\Logging\Exit-MSEScript.ps1
##################################################################################################################################################
#################################################################################################################################################
# Function Exit-MSEScript                                                                                                   
#################################################################################################################################################
<#
  .SYNOPSIS
    Write closing logging data & exit

  .DESCRIPTION
    Writes finishing logging data to specified log and then exits the calling script
  
  .PARAMETER LogPath
    Mandatory. Full path of the log file you want to write finishing data to. Example: C:\Windows\Temp\Test_Script.log

  .PARAMETER ScriptExit
    Optional. If this is set to True, then the function will exit the calling script, so that further execution can occur
  
  .INPUTS
    Parameters above

  .OUTPUTS
    None

  .NOTES
    Version:        1.0
    Author:         Luca Sturlese
    Creation Date:  10/05/12
    Purpose/Change: Initial function development
    
    Version:        1.1
    Author:         Luca Sturlese
    Creation Date:  19/05/12
    Purpose/Change: Added debug mode support
  
    Version:        1.2
    Author:         Luca Sturlese
    Creation Date:  01/08/12
    Purpose/Change: Added option to not exit calling script if required (via optional parameter)

    Version:        1.3
    Author: 	    Ron Gines
    Date:           02/05/2015
    Change: 	    Cleaned up for use in first NPPC release

    Version:        1.4
    Author: 	    Ron Gines
    Date:           04/14/2021
    Change: 	    Cleaned up for use in first NPPC release

  .EXAMPLE
    Exit-MSEScript -LogPath "C:\Windows\Temp\Test_Script.log"

  .EXAMPLE
    Exit-MSEScript -LogPath $MyLogPath -ScriptExit $True

  .EXAMPLE
    Exit-MSEScript -LogPath "C:\Windows\Temp\Test_Script.log" -ScriptExit $False
#>
Function Exit-MSEScript
{
  [CmdletBinding(SupportsShouldProcess=$True)]
  Param ([Parameter(Mandatory=$true)][string]$LogPath, 
         [Parameter(Mandatory=$false)][bool]$ScriptExit = $true
  )
  
    $FunctionName = "End-MSEScript"
    If (!(Test-Path -Path $LogPath)){
        (Add-Content -Path $LogPath -Value "***************************************************************************************************")
        (Add-Content -Path $LogPath -Value "Started processing at [$([DateTime]::Now)].")
        (Add-Content -Path $LogPath -Value "***************************************************************************************************")
    }

    Close-MSELogFile $LogPath 

    #Write to screen for debug mode
    Write-Debug "" 
    Write-Debug "***************************************************************************************************"
    Write-Debug "Finished processing at [$([DateTime]::Now)]."
    Write-Debug "***************************************************************************************************"
  
    #Exit calling script if ScriptExit has been set to true
    If($ScriptExit){
      Exit
    }    
} # End Function Exit-MSEScript


##################################################################################################################################################
# Sourced from file named:
#       .\TFS-MSE-AutomationInfrastructure\MSEAutomation\Code\Functions\Logging\Get-MSEUniqueTimeStamp.ps1
##################################################################################################################################################
#################################################################################################################################################
# Function Get-MSEUniqueTimeStamp                                                                                          
#################################################################################################################################################
<# 
   .SYNOPSIS 
	  Function will return a character strng that can be used in timestamping a file name.

   .DESCRIPTION 
	  Function will return a character strng that can be used in timestamping a file name.

   .PARAMETER
      LogePath (required).   Specify the log path for the log file to be written to.

   .NOTES 
      Author       : 	Ron Gines
      Version      :    1.0
      Date         : 	05/05/2016
      Description  :    Cleaned up for first NPPC release

      Author       : 	Ron Gines
      Version      :    1.1
      Date         : 	04/14/2021
      Description  :    Cleaned up for first MSE release

   .EXAMPLE   
	  $CharacterString = Get-MSEUniqueTimeStamp
#> 
Function Get-MSEUniqueTimeStamp
{
   [CmdletBinding(SupportsShouldProcess=$True)]
   Param ([Parameter(Mandatory=$false)][string]$LogPath)
   
   # Clean up variables and define in-house variables
   $FunctionName  = "Get-MSEUniqueTimeStamp"
   
   If ($LogPath -ne $null)
   {
      If ($LogPath) {Write-MSELogFile $LogPath "$($FunctionName): -------------------------------------" $false}
      If ($LogPath) {Write-MSELogFile $LogPath "$($FunctionName): >>>>>Loading" $false}
   }
   $CurrentDate = Get-Date -format g
   $DateSplit = $CurrentDate -split "/"
   $xMo = $DateSplit[0]
   if ($xMo.length -eq 1){$xMo = "0$xMo"}
   $xDa = $DateSplit[1]
   if ($xDa.length -eq 1){$xDa = "0$xDa"}
   $DateSplit2 = $DateSplit[2] -split " "
   $xYe = $DateSplit2[0]
   $AMPM = $DateSplit2[2]
   $DateSplit3 = $DateSplit2[1] -split ":"
   $UniqueDate = $xYe+$xMo+$xDa+"."+$DateSplit3[0]+$DateSplit3[1]+$AMPM
   return $UniqueDate

} # End function Get-MSEUniqueTimeStamp

##################################################################################################################################################
# Sourced from file named:
#       .\TFS-MSE-AutomationInfrastructure\MSEAutomation\Code\Functions\Logging\Open-MSELogFile.ps1
##################################################################################################################################################
#################################################################################################################################################
# Function Open-MSELogFile                                                                                                  
#################################################################################################################################################
<# 
  .SYNOPSIS
    Creates a local text log file log file

  .DESCRIPTION
    Creates log file with path and name that is passed. Checks if log file exists, and if it does deletes it and creates a new one.
    Once created, writes initial logging data

  .PARAMETER LogPath
    Mandatory. Path of where log is to be created. Do not include the trailing '\'   .Example: C:\Windows\Temp

  .PARAMETER LogName
    Mandatory. Name of log file to be created. Example: Test_Script.log
      
  .PARAMETER ScriptVersion
    Mandatory. Version of the running script which will be written in the log. Example: 1.5

  .INPUTS
    Parameters above

  .OUTPUTS
    Log file created

  .NOTES
    Version:        1.0
    Author:         Luca Sturlese
    Creation Date:  10/05/12
    Purpose/Change: Initial function development

    Version:        1.1
    Author:         Luca Sturlese
    Creation Date:  19/05/12
    Purpose/Change: Added debug mode support

    Version:        1.2
    Author: 	    Ron Gines
    Date:           02/05/2015
    Change: 	    Cleaned up for use in first NPPC release

    Version:        1.3
    Author: 	    Ron Gines
    Date:           04/14/2021
    Change: 	    Cleaned up for use in first MSE release

  .EXAMPLE
    Open-MSELogFile -LogPath "C:\Windows\Temp" -LogName "Test_Script.log" -ScriptVersion "1.5"
  #>
   
Function Open-MSELogFile
{
  [CmdletBinding(SupportsShouldProcess=$True)]
  
  Param ([Parameter(Mandatory=$true)][string]$LogPath, 
         [Parameter(Mandatory=$true)][string]$LogName, 
         [Parameter(Mandatory=$true)][string]$ScriptVersion
  ) # End Param

  # Clean up variables and define in-house variables

  $FunctionName = "Open-MSELogFile"
  $LogPath = $LogPath.TrimEnd('\') 
  $sFullPath = $LogPath + "\" + $LogName

  #Check if file exists and delete if it does
  If(Test-Path -Path $sFullPath){
    Remove-Item -Path $sFullPath -Force
  }
    
  #Create file and start logging
    
  (Add-Content -Path $sFullPath -Value "***************************************************************************************************")
  (Add-Content -Path $sFullPath -Value "Started processing at [$([DateTime]::Now)].")
  (Add-Content -Path $sFullPath -Value "***************************************************************************************************")
  (Add-Content -Path $sFullPath -Value "")
  (Add-Content -Path $sFullPath -Value "Function Name: [$FunctionName]")
  (Add-Content -Path $sFullPath -Value "Running script version [$ScriptVersion].")
  (Add-Content -Path $sFullPath -Value "")
  (Add-Content -Path $sFullPath -Value "***************************************************************************************************")
  (Add-Content -Path $sFullPath -Value "")
  
  #Write to screen for debug mode
  Write-Debug "***************************************************************************************************"
  Write-Debug "Started processing at [$([DateTime]::Now)]."
  Write-Debug "***************************************************************************************************"
  Write-Debug "Function Name: [$FunctionName]"
  Write-Debug ""
  Write-Debug "Running script version [$ScriptVersion]."
  Write-Debug ""
  Write-Debug "***************************************************************************************************"
  Write-Debug ""
} # End function Open-MSELogFile

##################################################################################################################################################
# Sourced from file named:
#       .\TFS-MSE-AutomationInfrastructure\MSEAutomation\Code\Functions\Logging\Write-MSEErrorToLogFile.ps1
##################################################################################################################################################
################################################################################################################################################
# Function Write-MSEErrorToLogFile                                                                                                 
#################################################################################################################################################
<# 
  .SYNOPSIS
    Writes an error to a log file

  .DESCRIPTION
    Writes the passed error to a new line at the end of the specified log file
  
  .PARAMETER LogPath
    Mandatory. Full path of the log file you want to write to. Example: C:\Windows\Temp\Test_Script.log
  
  .PARAMETER ErrorDesc
    Mandatory. The description of the error you want to pass (suggest using $_.Exception from within calling script)
  
  .PARAMETER ExitGracefully
    Mandatory. Boolean. Default is $false. If set to $true, runs Log-Finish and then exits script

  .INPUTS
    Parameters above

  .OUTPUTS
    None


  .NOTES
    Version:        1.0
    Author:         Luca Sturlese
    Creation Date:  10/05/12
    Purpose/Change: Initial function development

    Version:        1.1
    Author:         Luca Sturlese
    Creation Date:  19/05/12
    Purpose/Change: Added debug mode support

    Version:        1.2
    Author: 	    Ron Gines
    Date:           02/05/2015
    Change: 	    Cleaned up for use in first NPPC release

    Version:        1.3
    Author: 	    Ron Gines
    Date:           04/14/2021
    Change: 	    Cleaned up for use in first MSE release

  .EXAMPLE
    Write-MSEErrorToLogFile -LogPath "C:\Windows\Temp\Test_Script.log" -ErrorDesc $_.Exception -ExitGracefully $True
#>
#####################
#####################
# TODO: Need to add option to output to screen as well with red coloring.
#####################
#####################

Function Write-MSEErrorToLogFile
{
  [CmdletBinding(SupportsShouldProcess=$True)]
  Param ([Parameter(Mandatory=$true,Position=0)][string]$LogPath, 
         [Parameter(Mandatory=$true,Position=1)][string]$ErrorDesc, 
         [Parameter(Mandatory=$false,Position=2)][boolean]$ExitGracefully
  )
  
  $FunctionName = "Write-MSEErrorToLogFile"
    If (!(Test-Path -Path $LogPath)){
     (Add-Content -Path $LogPath -Value "***************************************************************************************************")
     (Add-Content -Path $LogPath -Value "Started processing at [$([DateTime]::Now)].")
     (Add-Content -Path $LogPath -Value "***************************************************************************************************")
  }

  Write-MSELogFile $LogPath "$($FunctionName): -------------------------------------" $false
  Write-MSELogFile $LogPath "$($FunctionName): >>>>>Loading" $false

  Write-MSELogFile $LogPath -Value "ERROR: An error has occurred [$ErrorDesc]."
   
  #Write to screen for debug mode
  Write-Debug "ERROR: An error has occurred [$ErrorDesc]."
    
  #If $ExitGracefully = True then run Log-Finish and exit script
  If ($ExitGracefully -eq $True){
    Write-MSELogFile $LogPath "Exiting as instructed after an error." $true
    Exit-MSEScript -LogPath $LogPath -ScriptExit $True
    Break
  }
} # End Function Write-MSEErrorToLogFile

##################################################################################################################################################
# Sourced from file named:
#       .\TFS-MSE-AutomationInfrastructure\MSEAutomation\Code\Functions\Logging\Write-MSELogFile.ps1
##################################################################################################################################################
#################################################################################################################################################
# Function Write-MSELogFile                                                                                                   
#################################################################################################################################################
<# 
  .SYNOPSIS
    Writes to a log file

  .DESCRIPTION
    Appends a new line to the end of the specified log file

  .PARAMETER LogPath
    Mandatory. Full path of the log file you want to write to. Example: C:\Windows\Temp\Test_Script.log
  
  .PARAMETER LineValue
    Mandatory. The string that you want to write to the log

  .PARAMETER Screen
    Boolean.   Will write log vlaue out to screen if value is $true.  Default is $false
      
  .INPUTS
    Parameters above

  .OUTPUTS
    None

  .NOTES
    Version:        1.0
    Author:         Luca Sturlese
    Creation Date:  10/05/12
    Purpose/Change: Initial function development

    Version:        1.1
    Author:         Luca Sturlese
    Creation Date:  19/05/12
    Purpose/Change: Added debug mode support

    Version:        1.2
    Author: 	    Ron Gines
    Date:           02/05/2015
    Change: 	    Cleaned up for use in first NPPC release

    Version:        1.3
    Author: 	    Ron Gines
    Date:           04/14/2021
    Change: 	    Cleaned up for use in first MSE release

  .EXAMPLE
    No Screen Output
    Write-MSELogFile -LogPath "C:\Windows\Temp\Test_Script.log" -LineValue "This is a new line which I am appending to the end of the log file."

  .EXAMPLE
    Screen Output
    Write-MSELogFile -LogPath "C:\Windows\Temp\Test_Script.log" -LineValue "This is a new line which I am appending to the end of the log file." $true
  #>
  
Function Write-MSELogFile
{
  [CmdletBinding(SupportsShouldProcess=$True)]
  Param ([Parameter(Mandatory=$true,Position=0)][string]$LogPath, 
         [Parameter(Mandatory=$false,Position=1)][string]$LineValue,
         [Parameter(Mandatory=$false,Position=2)][bool]$Screen = $false
  ) # End Param

  # Clean up variables and define in-house variables
  $FunctionName = "Write-MSELogFile"

  If (!(Test-Path -Path $LogPath)){
     (Add-Content -Path $LogPath -Value "***************************************************************************************************")
     (Add-Content -Path $LogPath -Value "Started processing at [$([DateTime]::Now)].")
     (Add-Content -Path $LogPath -Value "***************************************************************************************************")
  }

  If (($LineValue -eq $null) -or ($LineValue -eq "")) {$LineValue = " - - - << No Logging Data Supplied >> - - - -"}
  $TempTimeStamp = Get-Date -format yyyyMMddHHmmss
  $LineOut = "$($TempTimeStamp) - $($LineValue)"

  # Write to local log file
  (Add-Content -Path $LogPath -Value $LineOut)

  # Write to screen if instructed
  If ($Screen){
    Write-Host $Lineout
  }
  
  # Write to screen for debug mode
  Write-Debug $LineOut

} # End function Write-MSELogFile 

Export-ModuleMember *

