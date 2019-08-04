function Hammer-Maths {
    Param (
        [Parameter(Mandatory=$true)]
        [ValidateRange('Positive')]
        [int]
        $bs,
        [Parameter(Mandatory=$true)]
        [ValidateRange('Positive')]
        [int]
        $models,
        [Parameter(Mandatory=$true)]
        [ValidateRange('Positive')]
        [int]
        $attacks,
        [Parameter(Mandatory=$true)]
        [ValidateRange('Positive')]
        [int]
        $s,
        [Parameter(Mandatory=$true)]
        [ValidateRange('Positive')]
        [int]
        $t,
        [Parameter(Mandatory=$false)]
        [ValidateRange('NonNegative')]
        [int]
        $ap = 0,
        [Parameter(Mandatory=$false)]
        [ValidateRange('NonNegative')]
        [int]
        $save = 0,
        [Parameter(Mandatory=$false)]
        [ValidateRange('NonNegative')]
        [int]
        $invulnerableSave = 0,
        [Parameter(Mandatory=$true)]
        [ValidateRange('Positive')]
        [int]
        $damage,
        [Parameter(Mandatory=$true)]
        [ValidateRange('Positive')]
        [int]
        $targetWounds,
        [Parameter(Mandatory=$true)]
        [ValidateRange(1,50)]
        [int]
        $targetModels,
        [Parameter(Mandatory=$true)]
        [ValidateRange('Positive')]
        [int]
        $leadership
    )

$responseObject = @{
    totalDamage = 0
    destroyedModels = 0
    cravenModels = 0
}


# First we roll to hit
$totalHits = getHits -bs $bs -Models $models -Attacks $Attacks

if ($totalHits -gt 0) {
    # Then we roll to wound
    $totalWounds = getWounds -hits $totalHits -s $s -t $t

    if ($totalWounds -gt 0) {
        # Then we roll saves
        $totalUnsavedWouds = getUnsavedWounds -wounds $totalWounds -ap $ap -save $save -invulnerableSave $invulnerableSave

        if ($totalUnsavedWouds -gt 0) {
            # Then we roll damage
            $responseObject = getDamage -unsavedWounds $totalUnsavedWouds -damage $damage -targetWouds $targetWounds -targetModels $targetModels

            if ($responseObject.destroyedModels -gt 0 -and $responseObject.destroyedModels -lt $targetModels) {
                # Check for fleeing models
                $responseObject.cravenModels = getCravens -remainingModels ($targetModels - $responseObject.destroyedModels) -destroyedModels $responseObject.destroyedModels -leadership $leadership
            }
        }
    }
}

$responseObject | ConvertTo-Json
