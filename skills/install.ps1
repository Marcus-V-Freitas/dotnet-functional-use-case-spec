param(
    [ValidateSet("github","claude","gemini","antigravity","all")]
    [string]$Target = "all",
    [ValidateSet("user","project")]
    [string]$Scope = "project",
    [string]$ProjectPath = (Get-Location).Path
)

$ErrorActionPreference = "Stop"
$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$Source = Join-Path $ScriptRoot "dotnet-functional-use-case-spec"

function Install-Skill([string]$Root) {
    $Destination = Join-Path $Root "dotnet-functional-use-case-spec"
    New-Item -ItemType Directory -Force -Path $Root | Out-Null
    if (Test-Path $Destination) { Remove-Item -Recurse -Force $Destination }
    Copy-Item -Recurse -Force $Source $Destination
    Write-Host "Installed: $Destination"
}

function Install-Target([string]$Name) {
    if ($Scope -eq "project") {
        switch ($Name) {
            "github"      { Install-Skill (Join-Path $ProjectPath ".github\skills") }
            "claude"      { Install-Skill (Join-Path $ProjectPath ".claude\skills") }
            "gemini"      { Install-Skill (Join-Path $ProjectPath ".gemini\skills") }
            "antigravity" { Install-Skill (Join-Path $ProjectPath ".agents\skills") }
        }
    } else {
        switch ($Name) {
            "github"      { Install-Skill (Join-Path $HOME ".copilot\skills") }
            "claude"      { Install-Skill (Join-Path $HOME ".claude\skills") }
            "gemini"      { Install-Skill (Join-Path $HOME ".gemini\skills") }
            "antigravity" { Install-Skill (Join-Path $HOME ".gemini\antigravity\skills") }
        }
    }
}

if ($Target -eq "all") {
    @("github","claude","gemini","antigravity") | ForEach-Object { Install-Target $_ }
} else {
    Install-Target $Target
}
