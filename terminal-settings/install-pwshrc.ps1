#!/bin/pwsh

Write-Output "Copying pwsh profile to ~/.pwshrc.ps1..."
Copy-Item pwshrc.ps1 ~/.pwshrc.ps1

$machinSpecificProfile = Join-Path $HOME .pwshrc-machine-specific.ps1

if(Test-Path $machinSpecificProfile) 
{
    Write-Output "~/.pwshrc-machine-specific.ps1 file already exists..."
}
else 
{
    Write-Output "Creating blank ~/.pwshrc-machine-specific.ps1 file..."
    New-Item ~/.pwshrc-machine-specific.ps1 -Force
}

$osPlatform = [System.Environment]::OSVersion.Platform

if($osPlatform -eq 'MacOSX' -or $osPlatform -eq 'Unix')
{
    $profilePaths = (
        Join-Path $HOME ".config/powershell/profile.ps1"
    )
}
else 
{
    $myDocumentsPath = [Environment]::GetFolderPath("MyDocuments")
    $profilePaths = (
        $(Join-Path $myDocumentsPath "WindowsPowerShell\Profile.ps1"),
        $(Join-Path $myDocumentsPath "PowerShell\Profile.ps1")
    )
}

$pwshrcPath = Join-Path $HOME .pwshrc.ps1

foreach($profilePath in $profilePaths) 
{
    if(-Not (Test-Path $profilePath))
    {
        New-Item $profilePath -Force
    }

    if(Select-String -Path $profilePath -Pattern "# Import Custom Profile.") 
    {
        Write-Output "Profile already imported in $profilePath"
    }
    else 
    {
        Write-Output "Importing profile in $profilePath"
        Add-Content $profilePath "`n# Import Custom Profile.`n. $pwshrcPath"
    } 
}

Write-Output "Done. For PowerShell 5.x you may need to run the following command:"
Write-Output "  Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser"