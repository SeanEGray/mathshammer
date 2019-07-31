function getHits {
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
        $attacks
    )

    $totalAttacks = $attacks * $models

    if ($bs -eq 1) {
        # Natural 1s always fail
        $bs = 2
    }
    $chanceToHit = (7 - $bs) / 6

    $totalHits = $totalAttacks * $chanceToHit
    return $totalHits 
}