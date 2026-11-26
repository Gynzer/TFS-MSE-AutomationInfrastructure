<#  MSEBuildEnvironment.ps1

This is simply a variable script which defines the MSEAutomation Build environment.   

#>

$RepositoryRootPath        = "C:\Users\ron.gines\OneDrive - Thermo Fisher Scientific\Documents\GitHub\TFS-MSE-AutomationInfrastructure"

#The following directories are identified relative to the RepositoryRootPathPath
$BuildDirectory            = "Build"
$TestDirectory             = "Tests"
$ReleaseDirectory          = "Release"
$PublicFunctionsDirectory  = @(
	"MSEAutomation\Code\Functions"
    )
$PrivateFunctionsDirectory = @(
    "MSEAutomation\Code\Private"
	)

#Files relative to $RepositoryRootPath
$ReleaseNotesFile          = "Release-Notes.md"


#Module Manifest Data
$ModuleToBuild             = "MSEAutomation"
$ModuleVersion             = "0.0.1"
$ModuleWebsite             = "https://github.com/Ron-Gines/TFS-MSE-AutomationInfrastructure"
$ModuleCopyright           = "(c) $((get-date).Year.ToString()) Thermo Fisher Scientific. All rights reserved."
$ModuleLicenseURI          = ""
$ModuleTags                = "MSE,Automation,Module" -split ','
$ModuleAuthor              = "Ron Gines"
$ModuleDescription         = "A PowerShell Infrastructure platform to facilitate the Automation of OT devices and systems."
$ModuleEncoding            = "uft8"
$ModuleCompanyName         = "Thermo Fisher Scientific" 
$ModuleAuthor              = 'Ron Gines'
$ModuleIncludeFiles        = @(
    "MSEAutomation\Code\CommonProperties\Configuration.psd1"
    )
