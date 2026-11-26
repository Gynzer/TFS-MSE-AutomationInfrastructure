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
