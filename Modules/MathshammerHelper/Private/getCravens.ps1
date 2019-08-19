function getCravens {
    Param (
        [Parameter(Mandatory=$true)]
        [ValidateRange(1,49)]
        [float]
        $remainingModels,
        [Parameter(Mandatory=$true)]
        [ValidateRange(1,49)]
        [float]
        $destroyedModels,
        [Parameter(Mandatory=$true)]
        [ValidateRange('Positive')]
        [int]
        $leadership
    )

    $averageTest = $destroyedModels + 3.5 # Average roll on 1D6 is 3.5

    if ($averageTest -gt $leadership) {
        $cravenModels = [Math]::min($averageTest - $leadership, $remainingModels)
    }
    else {
        $cravenModels = 0
    }

    return $cravenModels
}
