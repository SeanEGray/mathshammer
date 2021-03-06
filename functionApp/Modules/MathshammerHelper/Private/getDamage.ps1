function getDamage {
    Param (
        [Parameter(Mandatory=$true)]
        [ValidateRange('Positive')]
        [float]
        $unsavedWounds,
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
        $targetModels
    )

    $targetUnit = @()
    foreach ($m in 1 .. $targetModels) {
        $targetUnit += $targetWounds
    }

    $i = 0
    $totalDamage = 0
    foreach ($w in 1..$unsavedWounds) {
        if ($i -eq $targetModels) {
            break
        }
        foreach ($d in 1..$damage) {
            if ($i -eq $targetModels) {
                break
            }
            $targetUnit[$i] -= 1
            $totalDamage++
            if ($targetUnit[$i] -eq 0) {
                $i++
                break
            }
        }
    }

    $returnObject = @{
        totalDamage = $totalDamage
        destroyedModels = $targetUnit.where({($_ -eq 0)}).Count
    }

    return $returnObject
}