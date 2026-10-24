param(
    [ValidateSet("github", "claude", "gemini", "antigravity", "all")]
    [string]$Target = "all",
    [ValidateSet("user", "project")]
    [string]$Scope = "project",
    [string]$ProjectPath = (Get-Location).Path,
    [string]$Skill = "all"
)

$ErrorActionPreference = "Stop"
$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

# Discover available skills in the skills directory (directories containing SKILL.md)
$AvailableSkills = Get-ChildItem -Path $ScriptRoot -Directory | Where-Object {
    Test-Path (Join-Path $_.FullName "SKILL.md")
}

if ($Skill -ne "all") {
    $SelectedSkill = $AvailableSkills | Where-Object { $_.Name -eq $Skill }
    if (-not $SelectedSkill) {
        $Names = ($AvailableSkills | ForEach-Object { $_.Name }) -join ", "
        Write-Error "Skill '$Skill' not found in '$ScriptRoot'. Available skills: $Names"
        exit 1
    }
    $SkillsToInstall = @($SelectedSkill)
} else {
    $SkillsToInstall = @($AvailableSkills)
}

function Install-SkillDirectory([System.IO.DirectoryInfo]$SkillDir, [string]$DestinationRoot) {
    $SkillName = $SkillDir.Name
    $Destination = Join-Path $DestinationRoot $SkillName
    New-Item -ItemType Directory -Force -Path $DestinationRoot | Out-Null
    if (Test-Path $Destination) {
        Remove-Item -Recurse -Force $Destination
    }
    Copy-Item -Recurse -Force $SkillDir.FullName $Destination
    Write-Host "  -> Installed [$SkillName] to $Destination"
}

function Install-Target([string]$Name) {
    Write-Host "Installing to target: $Name (scope: $Scope)..." -ForegroundColor Cyan
    if ($Scope -eq "project") {
        $DestinationRoot = switch ($Name) {
            "github"      { Join-Path $ProjectPath ".github\skills" }
            "claude"      { Join-Path $ProjectPath ".claude\skills" }
            "gemini"      { Join-Path $ProjectPath ".gemini\skills" }
            "antigravity" { Join-Path $ProjectPath ".agents\skills" }
        }
        foreach ($s in $SkillsToInstall) {
            Install-SkillDirectory $s $DestinationRoot
        }
    } else {
        switch ($Name) {
            "github"      {
                $root = Join-Path $HOME ".copilot\skills"
                foreach ($s in $SkillsToInstall) { Install-SkillDirectory $s $root }
            }
            "claude"      {
                $root = Join-Path $HOME ".claude\skills"
                foreach ($s in $SkillsToInstall) { Install-SkillDirectory $s $root }
            }
            "gemini"      {
                $root = Join-Path $HOME ".gemini\skills"
                foreach ($s in $SkillsToInstall) { Install-SkillDirectory $s $root }
            }
            "antigravity" {
                $root1 = Join-Path $HOME ".gemini\antigravity\skills"
                $root2 = Join-Path $HOME ".gemini\config\skills"
                foreach ($s in $SkillsToInstall) {
                    Install-SkillDirectory $s $root1
                    Install-SkillDirectory $s $root2
                }
            }
        }
    }
}

$Targets = if ($Target -eq "all") {
    @("github", "claude", "gemini", "antigravity")
} else {
    @($Target)
}

foreach ($t in $Targets) {
    Install-Target $t
}

Write-Host "Done! ($($SkillsToInstall.Count) skill(s) installed for target(s): $($Targets -join ', '))" -ForegroundColor Green
