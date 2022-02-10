if(Get-Command "git" -ErrorAction SilentlyContinue) 
{ 
    if (-Not (Get-Module -ListAvailable -Name posh-git)) {
        Install-Module posh-git -Scope CurrentUser       
    } 

    Import-Module posh-git
}

if(Get-Command "microk8s" -ErrorAction SilentlyContinue) 
{ 
    Set-Alias mks -Value "microk8s" -Option AllScope
    Set-Alias kubectl -Value "microk8s kubectl" -Option AllScope
}

if(Get-Command "kubectl" -ErrorAction SilentlyContinue) 
{ 
    if (-Not (Get-Module -ListAvailable -Name PSKubectlCompletion)) {
        Install-Module PSKubectlCompletion -Scope CurrentUser        
    } 

    Import-Module PSKubectlCompletion  
    Set-Alias k -Value kubectl -Option AllScope
    Register-KubectlCompletion 
}

if(Get-Command "terraform" -ErrorAction SilentlyContinue) 
{ 
    Set-Alias tf -Value terraform -Option AllScope
}

if(Test-Path "$HOME\.kube\config")
{
    $env:KUBECONFIG="$env:KUBECONFIG;$HOME\.kube\config" 
}

if(Test-Path "c:\Program Files\Sublime Text\sublime_text.exe")
{
    Set-Alias edit -Value sublime_text -Option AllScope
}
elseif(Get-Command "code-insiders.exe" -ErrorAction SilentlyContinue) 
{
    Set-Alias edit -Value code-insiders -Option AllScope
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

Remove-Item Alias:cd

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

$machinSpecificProfile = Join-Path $HOME .pwshrc-machine-specific.ps1

if(Test-Path $machinSpecificProfile) 
{
    . $machinSpecificProfile
}

ws | Out-Null

Get-Date