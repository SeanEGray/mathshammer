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

Set-Location -Path $Path

& ~/terraform init

if ($PSCmdlet.ShouldProcess($Path, 'terraform apply')) {
    & ~/terraform apply -input=false -auto-approve
}
