using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Warning "New request: $($Request.Body)"

Import-Module MathshammerHelper

$inputSplat = @{ 
    bs = $Request.Body.bs 
    models = $Request.Body.models 
    attacks = $Request.Body.attacks 
    s = $Request.Body.s 
    t = $Request.Body.t 
    ap = $Request.Body.ap 
    save = $Request.Body.save 
    invulnerableSave = $Request.Body.invulnerableSave 
    damage = $Request.Body.damage 
    targetWounds = $Request.Body.targetWounds 
    targetModels = $Request.Body.targetModels 
    leadership = $Request.Body.leadership 
}

$responseObject = Hammer-Maths @inputSplat

$status = [HttpStatusCode]::OK
$body = $responseObject | ConvertTo-Json

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = $status
    Body = $body
})
