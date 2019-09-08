Param (
    # Version of terraform to install
    [Parameter(Mandatory = $false)]
    [String]
    $Version = '0.12.7'
)

$downloadUrl = "https://releases.hashicorp.com/terraform/$version/terraform_$($version)_linux_amd64.zip"

"Downloading $downloadUrl"

Invoke-WebRequest -Uri $downloadUrl -OutFile "$($env:temp)/terraform.zip"

Expand-Archive -Path "$($env:temp)/terraform.zip" -DestinationPath './' -Force

$PWD
