function getHits {
    Param (
        [Parameter(Mandatory=$true)]
        [ValidateRangeKind(Positive)]
        [int]
        $bs,
        [Parameter(Mandatory=$true)]
        [ValidateRangeKind(Positive)]
        [int]
        $numModels,
        [Parameter(Mandatory=$true)]
        [ValidateRangeKind(Positive)]
        [int]
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