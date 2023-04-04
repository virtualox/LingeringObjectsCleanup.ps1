<#
.SYNOPSIS
    A PowerShell script to detect and clean up lingering objects in Active Directory.

.DESCRIPTION
    This script checks for lingering objects on all domain controllers in the current Active Directory domain.
    It offers an optional -CheckOnly switch that, when provided, will only check for lingering objects without removing them.
    To remove the lingering objects, run the script without the -CheckOnly switch.

.PARAMETER CheckOnly
    When this switch is provided, the script only checks for lingering objects and does not remove them.

.EXAMPLE
    .\LingeringObjectsCleanup.ps1 -CheckOnly

    This command checks for lingering objects without removing them.

.EXAMPLE
    .\LingeringObjectsCleanup.ps1

    This command removes lingering objects from all domain controllers in the current Active Directory domain.

.NOTES
    The script requires administrator privileges and the Active Directory module for PowerShell to be installed.
#>

param (
    [switch]$CheckOnly
)

function CheckAndRemoveLingeringObjects {
    param (
        [string]$PartitionDN,
        [string]$Server,
        [switch]$CheckOnly
    )

    $checkResult = repadmin /removelingeringobjects $Server $PartitionDN /Advisory_Mode

    if ($checkResult -match "No lingering objects found") {
        Write-Host "No lingering objects found in $PartitionDN on server $Server." -ForegroundColor Green
    } else {
        if ($CheckOnly) {
            Write-Host "Lingering objects detected in $PartitionDN on server $Server. To remove them, run the script without the -CheckOnly switch." -ForegroundColor Yellow
        } else {
            Write-Host "Removing lingering objects from $PartitionDN on server $Server..." -ForegroundColor Cyan
            $removeResult = repadmin /removelingeringobjects $Server $PartitionDN
            Write-Host "Lingering objects removal result:`n$removeResult" -ForegroundColor Magenta
        }
    }
}

# Load Active Directory module
if (-not (Get-Module -Name ActiveDirectory)) {
    Import-Module ActiveDirectory
}

$allDCs = Get-ADDomainController -Filter *

foreach ($dc in $allDCs) {
    $dcName = $dc.HostName
    $domainPartition = (Get-ADDomain).DistinguishedName
    $configPartition = (Get-ADRootDSE).configurationNamingContext
    $schemaPartition = (Get-ADRootDSE).schemaNamingContext

    Write-Host "`nChecking server $dcName for lingering objects..." -ForegroundColor White -BackgroundColor DarkCyan

    CheckAndRemoveLingeringObjects -PartitionDN $domainPartition -Server $dcName -CheckOnly:$CheckOnly
    CheckAndRemoveLingeringObjects -PartitionDN $configPartition -Server $dcName -CheckOnly:$CheckOnly
    CheckAndRemoveLingeringObjects -PartitionDN $schemaPartition -Server $dcName -CheckOnly:$CheckOnly
}
