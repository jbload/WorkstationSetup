$useOhMyPosh = $true
$useGit = $true
$useMicrok8s = $true
$useKubectl = $true
$useTerraform = $true
$useHelm = $true
$goToWorkspaceOnStartup = $true
$clearScreenOnStartup = $true
$workspace = "~/workspace"
$debug = $false

function Write-Debug
{
    param($message)

    if($debug)
    {
        Write-Host $message
    }    
}

if(Test-Path "$HOME\.pwshrc-options.ps1")
{
    Write-Debug "Loading .pwshrc-options.ps1"
    . "$HOME\.pwshrc-options.ps1"
}

if($useOhMyPosh) 
{
    if (-Not (Get-Module -ListAvailable -Name oh-my-posh)) 
    {
        Write-Debug "Installing oh-my-posh"
        Install-Module oh-my-posh -Scope CurrentUser       
    } 

    Write-Debug "Importing oh-my-posh"
    Import-Module oh-my-posh
    Write-Debug "Setting Posh-Prompt"
    Set-PoshPrompt -Theme Takuya
}

if($useGit) 
{
    if(Get-Command "git" -ErrorAction SilentlyContinue) 
    { 
        if (-Not (Get-Module -ListAvailable -Name posh-git)) {
            Write-Debug "Installing posh-git"
            Install-Module posh-git -Scope CurrentUser       
        } 

        Write-Debug "Importing posh-git"
        Import-Module posh-git
    }
}

if($useMicrok8s)
{
    if(Get-Command "microk8s" -ErrorAction SilentlyContinue) 
    { 
        Write-Debug "Setting microk8s aliases: mks, kubectl"
        Set-Alias mks -Value "microk8s" -Option AllScope
        Set-Alias kubectl -Value "microk8s kubectl" -Option AllScope
    }
}

if($useKubectl)
{
    if(Get-Command "kubectl" -ErrorAction SilentlyContinue) 
    { 
        if (-Not (Get-Module -ListAvailable -Name PSKubectlCompletion)) {
            Write-Debug "Installing PSKubectlCompletion"
            Install-Module PSKubectlCompletion -Scope CurrentUser        
        } 

        Write-Debug "Importing PSKubectlCompletion"
        Import-Module PSKubectlCompletion  

        Write-Debug "Setting kubectl alias: k"
        Set-Alias k -Value kubectl -Option AllScope

        Write-Debug "Registering KubectlCompletion"
        Register-KubectlCompletion 
    }

    if(Test-Path "$HOME\.kube\config")
    {
        if($env:KUBECONFIG)
        {
            $env:KUBECONFIG="$env:KUBECONFIG;$HOME\.kube\config" 
        }
        else
        {
            $env:KUBECONFIG="$HOME\.kube\config" 
        }

        Write-Debug "Setting KUBCONFIG environment variable to: $env:KUBECONFI"
    }
}

if($useTerraform)
{
    if(Get-Command "terraform" -ErrorAction SilentlyContinue) 
    { 
        Write-Debug "Setting terraform alias: tf"
        Set-Alias tf -Value terraform -Option AllScope
    }
}

if($useHelm)
{
    if(Test-Path "$HOME\.helm-completion.ps1")
    {
        Write-Debug "Installing .helm-completion.ps1"
        . "$HOME\.helm-completion.ps1"
    }
}

if(Test-Path "c:\Program Files\Sublime Text\sublime_text.exe")
{
    Set-Alias edit -Value sublime_text -Option AllScope
}
elseif(Test-Path "/usr/local/bin/subl")
{
    Set-Alias edit -Value subl -Option AllScope
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
$env:WORKSPACE = $workspace

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

function Remove-BinFolders() 
{
    $binFolders = Get-ChildItem -Directory -Include bin,obj -Recurse -Force -Depth 10 | Where-Object { -Not $_.FullName.Contains("Node_modules", "OrdinalIgnoreCase") }

    foreach($binFolder in $binFolders) 
    {
        $fullPath = $binFolder.FullName
        Write-Host "Removing folder: $fullPath"
        Remove-Item $binFolder.FullPath -Force -Recurse
    }    
}

if(Test-Path "$HOME\.pwshrc-customizations.ps1")
{
    Write-Debug "Loading .pwshrc-customizations.ps1"
    . "$HOME\.pwshrc-customizations.ps1"
}

if($goToWorkspaceOnStartup)
{
    ws | Out-Null
}

if($clearScreenOnStartup -and -not $debug)
{
    Clear-Host
}

Get-Date