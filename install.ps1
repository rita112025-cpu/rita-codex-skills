[CmdletBinding()]
param(
    [string]$TargetRoot = (Join-Path $HOME ".codex\skills"),
    [switch]$NoBackup
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$RepoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

if (-not (Test-Path -LiteralPath $RepoRoot -PathType Container)) {
    throw "Repository root not found: $RepoRoot"
}

$SkillDirs = Get-ChildItem -LiteralPath $RepoRoot -Directory | Where-Object {
    Test-Path -LiteralPath (Join-Path $_.FullName "SKILL.md") -PathType Leaf
}

if (-not $SkillDirs) {
    throw "No skill directories containing SKILL.md were found in: $RepoRoot"
}

New-Item -ItemType Directory -Force -Path $TargetRoot | Out-Null

$BackupRoot = $null
if (-not $NoBackup) {
    $Timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $BackupRoot = Join-Path (Split-Path -Parent $TargetRoot) "skills-backup\$Timestamp"
}

$Installed = @()
$BackedUp = @()

foreach ($SkillDir in $SkillDirs) {
    $SkillName = $SkillDir.Name
    $Source = $SkillDir.FullName
    $Destination = Join-Path $TargetRoot $SkillName

    if (Test-Path -LiteralPath $Destination) {
        if (-not $NoBackup) {
            New-Item -ItemType Directory -Force -Path $BackupRoot | Out-Null
            $BackupDestination = Join-Path $BackupRoot $SkillName
            Copy-Item -LiteralPath $Destination -Destination $BackupDestination -Recurse -Force
            $BackedUp += $SkillName
        }

        Remove-Item -LiteralPath $Destination -Recurse -Force
    }

    Copy-Item -LiteralPath $Source -Destination $Destination -Recurse -Force

    $InstalledSkillFile = Join-Path $Destination "SKILL.md"
    if (-not (Test-Path -LiteralPath $InstalledSkillFile -PathType Leaf)) {
        throw "Installation verification failed for skill: $SkillName"
    }

    $Installed += $SkillName
}

Write-Host ""
Write-Host "Codex skills installed successfully."
Write-Host "Target: $TargetRoot"
Write-Host "Installed: $($Installed -join ', ')"

if ($BackedUp.Count -gt 0) {
    Write-Host "Backup: $BackupRoot"
    Write-Host "Backed up: $($BackedUp -join ', ')"
}

Write-Host ""
Write-Host "Open a new Codex session so skill discovery can reload the installed skills."
