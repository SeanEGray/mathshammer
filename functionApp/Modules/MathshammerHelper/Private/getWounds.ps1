function getWounds {
    Param (
        [Parameter(Mandatory=$true)]
        [ValidateRange('Positive')]
        [float]
        $hits,
        [Parameter(Mandatory=$true)]
        [ValidateRange('Positive')]
        [int]
        $s,
        [Parameter(Mandatory=$true)]
        [ValidateRange('Positive')]
        [int]
        $t
    )

    if ($s -eq $t) {
        # 4+ to wound
        $roll = 4
    }
    elseif ($s -le ($t / 2)) {
        # 6+ to wound
        $roll = 6
    }
    elseif ($s -lt $t) {
        # 5+ to wound
        $roll = 5
    }
    elseif ($s -ge (2 * $t)) {
        # 2+ to wound
        $roll = 2
    }
    elseif ($s -gt $t) {
        # 3+ to wound
        $roll = 3
    }

    $chanceToWound = (7 - $roll) / 6

    $totalWounds = $hits * $chanceToWound
    return $totalWounds
}