function Hammer-Maths {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseApprovedVerbs", "")] # Executive decision that Hammer should be an approved verb
    Param (
        # Ballistic Skill
        [Parameter(Mandatory=$true)]
        [ValidateRange('Positive')]
        [int]
        $bs,
        # Number of attacking models
        [Parameter(Mandatory=$true)]
        [ValidateRange('Positive')]
        [int]
        $models,
        # Number of attacks per model
        [Parameter(Mandatory=$true)]
        [ValidateRange('Positive')]
        [int]
        $attacks,
        # Strength
        [Parameter(Mandatory=$true)]
        [ValidateRange('Positive')]
        [int]
        $s,
        # Toughness
        [Parameter(Mandatory=$true)]
        [ValidateRange('Positive')]
        [int]
        $t,
        # Armour-piercing value
        [Parameter(Mandatory=$false)]
        [ValidateRange('NonNegative')]
        [int]
        $ap = 0,
        # Armour save
        [Parameter(Mandatory=$false)]
        [ValidateRange('NonNegative')]
        [int]
        $save = 0,
        # Invulnerable save
        [Parameter(Mandatory=$false)]
        [ValidateRange('NonNegative')]
        [int]
        $invulnerableSave = 0,
        # Damage per unsaved wound
        [Parameter(Mandatory=$true)]
        [ValidateRange('Positive')]
        [int]
        $damage,
        # Wounds per target model
        [Parameter(Mandatory=$true)]
        [ValidateRange('Positive')]
        [int]
        $targetWounds,
        # Number of models in the target unit
        [Parameter(Mandatory=$true)]
        [ValidateRange(1,50)]
        [int]
        $targetModels,
        # Leadership of the target unit
        [Parameter(Mandatory=$true)]
        [ValidateRange('Positive')]
        [int]
        $leadership
    )

    $responseObject = @{
        totalHits = 0
        totalWounds = 0
        totalUnsavedWounds = 0
        totalDamage = 0
        destroyedModels = 0
        cravenModels = 0
    }


    # First we roll to hit
    $responseObject.totalHits = getHits -bs $bs -Models $models -Attacks $Attacks

    if ($responseObject.totalHits -gt 0) {
        # Then we roll to wound
        $responseObject.totalWounds = getWounds -hits $responseObject.totalHits -s $s -t $t

        if ($responseObject.totalWounds -gt 0) {
            # Then we roll saves
            $responseObject.totalUnsavedWounds = getUnsavedWounds -wounds $responseObject.totalWounds -ap $ap -save $save -invulnerableSave $invulnerableSave

            if ($responseObject.totalUnsavedWounds -gt 0) {
                # Then we roll damage
                $damageObject = getDamage -unsavedWounds $responseObject.totalUnsavedWounds -damage $damage -targetWounds $targetWounds -targetModels $targetModels
                $responseObject.totalDamage = $damageObject.totalDamage
                $responseObject.destroyedModels = $damageObject.destroyedModels

                if ($responseObject.destroyedModels -gt 0 -and $responseObject.destroyedModels -lt $targetModels) {
                    # Check for fleeing models
                    $responseObject.cravenModels = getCravens -remainingModels ($targetModels - $responseObject.destroyedModels) -destroyedModels $responseObject.destroyedModels -leadership $leadership
                }
            }
        }
    }

    $responseObject | ConvertTo-Json
}