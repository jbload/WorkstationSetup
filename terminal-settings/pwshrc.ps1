$ensureModulesInstalled = $true
$useOhMyPosh = $true
$ohMyPoshTheme = "$HOME\.oh-my-posh.justin.json" #Takuya
$useGit = $true
$useMicrok8s = $true
$useKubectl = $true
$useTerraform = $true
$useHelm = $true
$goToWorkspaceOnStartup = $false
$clearScreenOnStartup = $false
$workspace = "~/workspace"
$gitPushDuringSync = $false
$gitRepos = @()
$debug = $false

$env:GIT_DUET_ROTATE_AUTHOR = 1
$env:GIT_DUET_ALLOW_MULTIPLE_COMMITTERS = 1

$diagnostics = @()
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Description."
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No","Description."
$chooseYesOrNo = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)

function Write-Debug {
    param($message)

    if($debug) {
        Write-Host $message
    }    
}

function Confirm-ModuleInstalled {
    param([string]$moduleName)

    $result = $installedModules | Where-Object { $_.Name -eq $moduleName }
    $isInstalled = $result -ne $null

    Write-Debug "ModuleInstalled? $moduleName = $isInstalled"

    return $isInstalled
}

if(Test-Path "$HOME\.pwshrc-pre-init.ps1") {
    Write-Debug "Loading .pwshrc-pre-init.ps1"
    . "$HOME\.pwshrc-pre-init.ps1"
}

$isPackageManagerProfile = $PROFILE -like "*Nuget_profile.ps1"

if($ensureModulesInstalled) {
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $installedModules = Get-Module -ListAvailable
    $stopwatch.Stop()

    $diagnostics += "Get Available Modules: $($stopwatch.ElapsedMilliseconds) ms"
}

if($useOhMyPosh -and -not $isPackageManagerProfile) {
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

    Write-Debug "Setting Posh-Prompt"
    oh-my-posh init pwsh --config $ohMyPoshTheme | Invoke-Expression

    $stopwatch.Stop()
    $diagnostics += "Use OhMyPosh: $($stopwatch.ElapsedMilliseconds) ms"
}

if($useGit) {
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

    if(Get-Command "git" -ErrorAction SilentlyContinue) { 
        if($ensureModulesInstalled -and -not (Confirm-ModuleInstalled posh-git)) {
            Write-Debug "Installing posh-git"
            Install-Module posh-git -Scope CurrentUser       
        } 

        Write-Debug "Importing posh-git"
        Import-Module posh-git
    }

    $stopwatch.Stop()
    $diagnostics += "Use Posh-Git: $($stopwatch.ElapsedMilliseconds) ms"
}

if($useMicrok8s) {
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

    if(Get-Command "microk8s" -ErrorAction SilentlyContinue) { 
        Write-Debug "Setting microk8s aliases: mks, kubectl"
        Set-Alias mks -Value "microk8s" -Option AllScope
        Set-Alias kubectl -Value "microk8s kubectl" -Option AllScope
    }

    $stopwatch.Stop()
    $diagnostics += "Use MicroK8s: $($stopwatch.ElapsedMilliseconds) ms"
}

if($useKubectl) {
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

    if(Get-Command "kubectl" -ErrorAction SilentlyContinue) { 
        if($ensureModulesInstalled -and -not (Confirm-ModuleInstalled PSKubectlCompletion)) {
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

    $stopwatch.Stop()
    $diagnostics += "Use Kubectl: $($stopwatch.ElapsedMilliseconds) ms"
}

if($useTerraform) {
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

    if(Get-Command "terraform" -ErrorAction SilentlyContinue) { 
        Write-Debug "Setting terraform alias: tf"
        Set-Alias tf -Value terraform -Option AllScope
    }

    $stopwatch.Stop()
    $diagnostics += "Use Terraform: $($stopwatch.ElapsedMilliseconds) ms"
}

if($useHelm) {
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

    if(Test-Path "$HOME\.helm-completion.ps1") {
        Write-Debug "Installing .helm-completion.ps1"
        . "$HOME\.helm-completion.ps1"
    }

    $stopwatch.Stop()
    $diagnostics += "Use Helm: $($stopwatch.ElapsedMilliseconds) ms"
}

if(Test-Path "c:\Program Files\Sublime Text\sublime_text.exe") {
    Set-Alias edit -Value sublime_text -Option AllScope
}
elseif(Test-Path "/usr/local/bin/subl") {
    Set-Alias edit -Value subl -Option AllScope
}
elseif(Get-Command "code-insiders.exe" -ErrorAction SilentlyContinue) {
    Set-Alias edit -Value code-insiders -Option AllScope
}
elseif(Get-Command "code.exe" -ErrorAction SilentlyContinue) {
    Set-Alias edit -Value code -Option AllScope
}
else {
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
function gui { gradle-upgrade-interactive }
function ipInfo { ipconfig /all }
function ll { ls }
function myip { curl https://dynamicdns.park-your-domain.com/getip }
function path { Write-Host ($env:Path).Replace(";","`n") }
function ws { cd $env:WORKSPACE }
function ~ { cd ~ }
function yarnup { yarn set version stable }
function yui { yarn upgrade-interactive }

Remove-Item Alias:cd

function cd() {
    param($path)

    Set-Location $path
    Get-ChildItem .
}

function mcd() {
    param($path)

    mkdir $path
    cd $path
}

function gitsyncall() {
    $dirtyRepos = @()

    foreach($repo in $gitRepos) {
        Push-Location $repo

        if("$(git status --porcelain)".Length -gt 0) {
            $dirtyRepos += $repo
        }
        else {
            Write-Host "********************************************************************************"
            Write-Host "Synching git repo: $repo..."
            git up

            if($gitPushDuringSync) {
                git pushf
            }

            git com
            git up

            if($gitPushDuringSync) {
                git pushf
            }

            git co -
        }
        
        Pop-Location
    }

    if($dirtyRepos.Length -gt 0) {
        Write-Host "`nThe following repos were skipped because they had pending changes:"

        foreach($dirtyRepo in $dirtyRepos) {
            Write-Host "   $dirtyRepo"
        }
    }
}

function gitstall() {
    $cleanRepos = @()

    foreach($repo in $gitRepos) {
        Push-Location $repo

        if("$(git status --porcelain)".Length -gt 0) {   
            Write-Host "********************************************************************************"
            Write-Host "git status: $repo..."
            git st                     
        }
        else {
            $cleanRepos += $repo
        }

        Pop-Location
    }

    if($cleanRepos.Length -gt 0) {
        Write-Host "`nThe following repos were skipped because they had no pending changes:"

        foreach($cleanRepo in $cleanRepos) {
            Write-Host "   $cleanRepo"
        }
    }
}

function gitgcall() {
    foreach($repo in $gitRepos) {
        Push-Location $repo

        Write-Host "********************************************************************************"
        Write-Host "Performing maintenance on git repo: $repo..."
        gitgc

        Pop-Location
    }
}

function gitgc() {
    git maintenance run --task gc
}

function gitpruneall() {
    foreach($repo in $gitRepos) {
        Push-Location $repo

        Write-Host "********************************************************************************"
        Write-Host "Looking for local branches to delete from git repo: $repo..."
        gitprune

        Pop-Location
    }
}

function gitprune() {
    $branchNames = @()

    git branch | grep -v '^*\|master\|main' | ForEach-Object {
        $branchNames += $_.Trim()
    }

    if($branchNames.Length -gt 0) {
        Write-Host "`nLocal branches:"

        foreach($branchName in $branchNames) {
            Write-Host " $branchName"
        }

        Write-Host ""

        $choice = $host.ui.PromptForChoice("Delete Branches?", "Are you sure you want to remove these branches?", $chooseYesOrNo, 1)

        if($choice -eq 0) {
            foreach($branchName in $branchNames) {
                git branch -D $branchName
            } 
        }
        else {
            Write-Host "`nNo branches were deleted."
        }
    }
    else {
        Write-Host "There are no local branches to delete."
    }
}

function remind() {
    Write-Host "git:" -ForegroundColor Green
    Write-Host "- Delete remote branch: git push origin --delete branch_name"
    Write-Host "- Stop tracking a file: git update-index --assume-unchanged [<file>...]"
    Write-Host "- Fix 'refs/remotes/origin/HEAD is not a symbolic ref' error when using git com alias: git remote set-head origin master"
    Write-Host
    Write-Host 'Docker:' -ForegroundColor Green
    Write-Host "- Remove all Docker images: docker rmi \$(docker images -q) --force"
}

function Remove-BinFolders() {
    $binFolders = Get-ChildItem -Directory -Include bin,obj -Recurse -Force -Depth 10 | Where-Object { -Not $_.FullName.Contains("Node_modules", "OrdinalIgnoreCase") }

    foreach($binFolder in $binFolders) {
        $fullPath = $binFolder.FullName
        Write-Host "Removing folder: $fullPath"
        Remove-Item $binFolder.FullPath -Force -Recurse
    }    
}

if(Test-Path "$HOME\.pwshrc-post-init.ps1") {
    Write-Debug "Loading .pwshrc-post-init.ps1"
    . "$HOME\.pwshrc-post-init.ps1"
}

if($goToWorkspaceOnStartup) {
    ws | Out-Null
}

if($clearScreenOnStartup -and -not $debug) {
    Clear-Host
}

Get-Date

foreach($entry in $diagnostics) {
    Write-Debug $entry
}