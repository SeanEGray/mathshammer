function getUnsavedWounds {
    Param (
        [Parameter(Mandatory=$true)]
        [ValidateRange('Positive')]
        [int]
        $wounds,
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
        $invulnerableSave = 0
    )

    if ($save -eq 0) {
        $effectiveSave = 0
    }
    else {
        $effectiveSave = $save + $ap
    }
    
    if ($invulnerableSave -ne 0 -and $effectiveSave -gt $invulnerableSave) {
        $roll = $invulnerableSave
    }
    else {
        $roll = $effectiveSave
    }

    $chanceToUnsavedWound = (7 - $roll) / 6

    $totalUnsavedWounds = $hits * $chanceToUnsavedWound
    return $totalUnsavedWounds
}