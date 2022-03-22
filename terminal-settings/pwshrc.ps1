if (-Not (Get-Module -ListAvailable -Name oh-my-posh)) {
    Install-Module oh-my-posh -Scope CurrentUser       
} 

Import-Module oh-my-posh
Set-PoshPrompt -Theme Takuya

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

if(Test-Path "$HOME\.helm-completion.ps1")
{
    . "$HOME\.helm-completion.ps1"
}

if(Test-Path "c:\Program Files\Sublime Text\sublime_text.exe")
{
    Set-Alias edit -Value sublime_text -Option AllScope
}
if(Test-Path "/usr/local/bin/subl")
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

function Remove-OldGitTags() 
{
    param($recentTagCount=10, $tagFilter="tags/releases")

    $tagFileName = "git-tags.txt"
    git for-each-ref --format '%(refname)' --sort=taggerdate | Select-String -Pattern $tagFilter > $tagFileName

    $tagContent = Get-Content $tagFileName -Filter $tagFilter

    if($tagContent.Length -gt $recentTagCount) 
    {
        $oldTagCount = $tagContent.Length - $recentTagCount
        $oldTags = $tagContent[0..($oldTagCount - 1)]
        $i = 1
        
        foreach($oldTag in $oldTags)
        {
            Write-Host "Removing old git tag $i of $oldTagCount with: git push origin :$oldTag"
            git push origin :$oldTag
            $i += 1
        }

        Write-Host "Removed $oldTagCount old git tag$(if ($oldTagCount -gt 1) {"s."} else {"."})  Current tag count: $recentTagCount"
        
        git tag -l | %{git tag -d $_}
        git fetch --tags
        Write-Host "Pruned local tags."
    }
    else
    {
        Write-Host "No old git tags to remove. Current tag count: $($tagContent.Length)"
    }

    Remove-Item $tagFileName -Force -ErrorAction Ignore
}

if(Test-Path "$HOME\.pwshrc-machine-specific.ps1")
{
    . "$HOME\.pwshrc-machine-specific.ps1"
}

ws | Out-Null

Get-Date