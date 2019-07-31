function getHits {
    param (
        $bs,
        $numModels,
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