# Installs
# Install-Module PSKubectlCompletion

if(Get-Command "kubectl.exe" -ErrorAction SilentlyContinue) 
{ 
    Import-Module PSKubectlCompletion  
    Set-Alias k -Value kubectl -Option AllScope
    Register-KubectlCompletion 
}

if(Get-Command "terraform.exe" -ErrorAction SilentlyContinue) 
{ 
    Set-Alias tf -Value terraform -Option AllScope
}

if(Test-Path "c:\Program Files\Sublime Text\sublime_text.exe")
{
    Set-Alias edit -Value sublime_text -Option AllScope
}
elseif(Get-Command "code.exe" -ErrorAction SilentlyContinue) 
{
    Set-Alias edit -Value code -Option AllScope
}
else
{
    Set-Alias edit -Value notepad -Option AllScope
}

$env:NODE_OPTIONS = "--max_old_space_size=8192"
$env:PIPENV_VENV_IN_PROJECT = "1"
$env:ASPNETCORE_ENVIRONMENT = "Development"
$env:WORKSPACE = "~/workspace"

function .. { cd .. }
function ... { cd ../.. }
function .3 { cd ../../.. }
function .4 { cd ../../../.. }
function .5 { cd ../../../../.. }
function .6 { cd ../../../../../.. }
function psrc { . ~/Documents/PowerShell/Microsoft.PowerShell_profile.ps1 }
function cd.. { cd .. }
function cl { clear }
function DT { tee ~/Desktop/terminalOut.txt }
function editpsrc { edit ~/Documents/PowerShell/Microsoft.PowerShell_profile.ps1 }
function editgitconfig { edit ~/.gitconfig }
function f { explorer . }
function flushDNS { ipconfig /flushdns }
function ipInfo { ipconfig /all }
function ll { ls }
function myip { curl https://dynamicdns.park-your-domain.com/getip }
function path { echo ($env:Path).Replace(";","`n") }
function ws { cd $env:WORKSPACE }
function ~ { cd ~ }

Remove-Alias cd

function cd() 
{
    param($path)

    Set-Location $path
    Get-ChildItem .
}

function mcd() 
{
    param($path)

    mkdir $path
    cd $path
}

$machinSpecificProfile = Join-Path ([Environment]::GetFolderPath("MyDocuments")) PowerShell/Microsoft.PowerShell_profile_machine-specific.ps1

if(Test-Path $machinSpecificProfile) 
{
    . $machinSpecificProfile
}

Import-Module posh-git
ws | Out-Null

Get-Date