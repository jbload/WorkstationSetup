# To preserve machine-managed PowerShell profile entries, dot-source this file from $PROFILE:
# . "$HOME/src/Three21/WorkstationSetup/terminal-settings/pwshrc.shared.ps1"
#
# Machine-specific PowerShell settings can live in ~/.pwshrc.local-machine-config.ps1
# or ~/.pwshrc.local-machine-overrides.ps1.

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
$workspace = "~/src"
$gitPushDuringSync = $false
$gitRepos = @()
$debug = $false

$env:GIT_DUET_ROTATE_AUTHOR = 1
$env:GIT_DUET_ALLOW_MULTIPLE_COMMITTERS = 1
$env:CLAUDE_CODE_NO_FLICKER = 1

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

if(Test-Path "$HOME\.pwshrc.local-machine-config.ps1") {
    Write-Debug "Loading .pwshrc.local-machine-config.ps1"
    . "$HOME\.pwshrc.local-machine-config.ps1"
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
        function global:kubectl {
            microk8s kubectl @args
        }
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

Set-Alias cc -Value claude -Option AllScope
Set-Alias cx -Value codex -Option AllScope
Set-Alias oc -Value opencode -Option AllScope

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
function ccc { claude --continue @args }
function ccr { claude --resume @args }
function cl { clear }
function DT { tee ~/Desktop/terminalOut.txt }
function editpsrc { edit ~/Documents/PowerShell/Microsoft.PowerShell_profile.ps1 }
function editgitconfig { edit ~/.gitconfig }
function f { explorer . }
function flushDNS { ipconfig /flushdns }
function ghce { gh copilot explain @args }
function ghcs { gh copilot suggest @args }
function gui { gradle-upgrade-interactive }
function ipInfo { ipconfig /all }
function jup { jupyter lab @args }
function ll { ls }
function myip { curl https://dynamicdns.park-your-domain.com/getip }
function npmup { npm update -g }
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
    $script:gitSyncSkipped = @()

    foreach($repo in $gitRepos) {
        Write-Host "********************************************************************************"
        Write-Host "Synching git repo: $repo..."
        gitsyncrepo $repo
    }

    gitsyncreport
}

function gitsyncrepo() {
    param([string]$repo)

    git -C $repo fetch --prune origin

    if($LASTEXITCODE -ne 0) {
        return
    }

    $default = (git -C $repo symbolic-ref refs/remotes/origin/HEAD) -replace '^refs/remotes/origin/', ''

    if([string]::IsNullOrEmpty($default)) {
        gitsyncskip $repo "could not resolve the default branch"
        return
    }

    gitsyncdefault $repo $default

    foreach($worktree in (gitworktreebranches $repo)) {
        if($worktree.Branch -ne $default) {
            gitsyncworktree $worktree.Path $worktree.Branch
        }
    }
}

function gitsyncreport() {
    if($script:gitSyncSkipped.Length -gt 0) {
        Write-Host "`nThe following worktrees were skipped:"

        foreach($skipped in $script:gitSyncSkipped) {
            Write-Host "   $skipped"
        }
    }
}

function gitsyncdefault() {
    param([string]$repo, [string]$default)

    $worktree = (gitworktreebranches $repo | Where-Object { $_.Branch -eq $default } | Select-Object -First 1).Path

    if([string]::IsNullOrEmpty($worktree)) {
        Write-Host "Fast-forwarding $default..."
        git -C $repo fetch origin "$($default):$($default)"
    }
    elseif("$(git -C $worktree status --porcelain)".Length -gt 0) {
        gitsyncskip $worktree "$default has pending changes"
    }
    else {
        Write-Host "Fast-forwarding $default in $worktree..."
        git -C $worktree merge --ff-only "origin/$default"

        if($LASTEXITCODE -eq 0) {
            git -C $worktree submodule update --init --recursive
        }
    }
}

function gitsyncworktree() {
    param([string]$worktree, [string]$branch)

    git -C $worktree rev-parse --verify --quiet "@{u}" 2>$null | Out-Null
    $hasUpstream = $LASTEXITCODE -eq 0

    if([string]::IsNullOrEmpty($branch)) {
        gitsyncskip $worktree "detached HEAD"
    }
    elseif("$(git -C $worktree status --porcelain)".Length -gt 0) {
        gitsyncskip $worktree "$branch has pending changes"
    }
    elseif(-not $hasUpstream) {
        gitsyncskip $worktree "$branch has no upstream"
    }
    else {
        Write-Host "Rebasing $branch in $worktree..."
        git -C $worktree rebase "@{u}"

        if($LASTEXITCODE -eq 0) {
            git -C $worktree submodule update --init --recursive
        }

        if($gitPushDuringSync) {
            git -C $worktree pushf
        }
    }
}

function gitsyncskip() {
    param([string]$worktree, [string]$reason)

    $script:gitSyncSkipped += "$worktree ($reason)"
}

function gitworktreepaths() {
    param([string]$repo = '.')

    git -C $repo worktree list --porcelain | Where-Object { $_ -like 'worktree *' } | ForEach-Object { $_.Substring(9) }
}

function gitworktreebranches() {
    param([string]$repo = '.')

    $wtPath = $null
    $wtBranch = ''

    git -C $repo worktree list --porcelain | ForEach-Object {
        if($_ -like 'worktree *') {
            $wtPath = $_.Substring(9)
            $wtBranch = ''
        }
        elseif($_ -like 'branch refs/heads/*') {
            $wtBranch = $_.Substring(18)
        }
        elseif([string]::IsNullOrEmpty($_) -and $wtPath) {
            [pscustomobject]@{ Path = $wtPath; Branch = $wtBranch }
            $wtPath = $null
        }
    }

    if($wtPath) {
        [pscustomobject]@{ Path = $wtPath; Branch = $wtBranch }
    }
}

function gitworktreedirty() {
    $dirty = $false

    gitworktreepaths | ForEach-Object {
        if("$(git -C $_ status --porcelain)".Length -gt 0) {
            $dirty = $true
        }
    }

    return $dirty
}

function gitworktreestatus() {
    gitworktreepaths | ForEach-Object {
        if("$(git -C $_ status --porcelain)".Length -gt 0) {
            Write-Host "git status: $_..."
            git -C $_ st
        }
    }
}

function gitstall() {
    $cleanRepos = @()

    foreach($repo in $gitRepos) {
        Push-Location $repo

        if(gitworktreedirty) {
            Write-Host "********************************************************************************"
            Write-Host "git status: $repo..."
            gitworktreestatus
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

function gitall() {
    Write-Host "Synching all git repos..."
    gitsyncall

    Write-Host "Pruning all git repos..."
    gitpruneall

    Write-Host "GCing all git repos..."
    gitgcall
}

function gitbrall() {
    Write-Host "Current git branches:"

    foreach($repo in $gitRepos) {
        Push-Location $repo

        $isMain = $true

        $wtPath = $null
        $wtBranch = '(detached)'

        git worktree list --porcelain | ForEach-Object {
            if($_ -like 'worktree *') {
                $wtPath = $_.Substring(9)
                $wtBranch = '(detached)'
            }
            elseif($_ -like 'branch refs/heads/*') {
                $wtBranch = $_.Substring(18)
            }
            elseif([string]::IsNullOrEmpty($_)) {
                if($isMain) {
                    Write-Host "   - $wtBranch in $wtPath"
                    $isMain = $false
                }
                else {
                    Write-Host "      - $wtBranch in $wtPath"
                }

                $wtPath = $null
            }
        }

        Pop-Location
    }
}

function gitcowt() {
    param([string]$name)

    git cowt $name
    $wtPath = git wtpath $name

    if($LASTEXITCODE -eq 0) {
        cd $wtPath
    }
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
    $worktreePaths = @()
    $worktreeLabels = @()

    git worktree list | Select-Object -Skip 1 | ForEach-Object {
        $parts = $_ -split '\s+'
        $wtPath = $parts[0]
        $wtRef = ($parts[2..($parts.Length - 1)] -join ' ') -replace '^\[', '(' -replace '\]$', ')'
        $worktreePaths += $wtPath
        $worktreeLabels += "$wtPath $wtRef"
    }

    if($worktreePaths.Length -gt 0) {
        Write-Host "`nWorktrees:"

        foreach($label in $worktreeLabels) {
            Write-Host "   $label"
        }

        Write-Host ""

        $choice = $host.ui.PromptForChoice("Remove Worktrees?", "Are you sure you want to remove these worktrees?", $chooseYesOrNo, 1)

        if($choice -eq 0) {
            foreach($wtPath in $worktreePaths) {
                git worktree remove $wtPath
            }
        }
        else {
            Write-Host "`nNo worktrees were removed."
        }
    }

    $branchNames = @()

    git branch | Where-Object { $_ -notmatch '^\*|master|main' } | ForEach-Object {
        $branchNames += $_.Trim()
    }

    if($branchNames.Length -gt 0) {
        Write-Host "`nLocal branches:"

        foreach($branchName in $branchNames) {
            Write-Host "   $branchName"
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
    Write-Host "- Fix 'refs/remotes/origin/HEAD is not a symbolic ref' error when using git cod alias: git remote set-head origin master"
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

if(Test-Path "$HOME\.pwshrc.local-machine-overrides.ps1") {
    Write-Debug "Loading .pwshrc.local-machine-overrides.ps1"
    . "$HOME\.pwshrc.local-machine-overrides.ps1"
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
