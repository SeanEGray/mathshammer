<#
.Synopsis
    Invokes terraform
.DESCRIPTION
    Invokes terraform against the specified directory
.EXAMPLE
    ./Invoke-Terraform.ps1 -Path './terraform'
#>
[Cmdletbinding(SupportsShouldProcess = $true)]
Param (
    [Parameter(Mandatory = $true)]
    [string]$Path
)

$executable = "$((Get-Location).Path)/terraform"

Set-Location -Path $Path

Invoke-Expression $executable "init"

if ($PSCmdlet.ShouldProcess($Path, 'terraform apply')) {
    Invoke-Expression $executable "apply -input=false -auto-approve"
}
