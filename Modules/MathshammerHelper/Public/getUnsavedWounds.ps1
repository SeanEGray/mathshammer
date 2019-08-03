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

    if ($roll -eq 0) {
        $chanceToUnsavedWound = 1
    } 
    else {
        if ($roll -eq 1) {
            # Natural 1s always fail
            $roll = 2
        }
        $chanceToUnsavedWound = (($roll - 1) / 6)
    }
    

    $totalUnsavedWounds = $wounds * $chanceToUnsavedWound
    return $totalUnsavedWounds
}