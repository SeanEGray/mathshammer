function getHits {
    param (
        Parameter(Mandatory=$true)
        [ValidateRange(Positive)]
        [int]
        $bs,
        Parameter(Mandatory=$true)
        [ValidateRange(Positive)]
        [int]
        $numModels,
        Parameter(Mandatory=$true)
        [ValidateRange(Positive)]
        [int]
        [Validate]
        $attacks
    )

    $totalAttacks = $attacks * $numModels

    if ($bs -eq 1) {
        # Natural 1s always fail
        $bs = 2
    }
    $chanceToHit = (7 - $bs) / 6

    $totalHits = $totalAttacks * $chanceToHit
    return $totalHits 
}