Import-Module "../MathshammerHelper.psm1"

InModuleScope MathshammerHelper {
    # Some detaults
    $bs = 3
    $models = 10
    $attacks = 2
    $hits = 10
    $s = 4
    $t = 4
    $wounds = 5
    $ap = 1
    $save = 2
    $invulnerableSave = 4
    $unsavedWounds = 3
    $damage = 3
    $targetWounds = 2
    $targetModels = 5
    $remainingModels = 3
    $destroyedModels = 2
    $leadership = 8

    Describe 'Roll to hit' {
        Context 'Basic tests' {
            It 'Calculates basic scenarios correclty' {
                foreach ($i in (2..6)) {
                    getHits -bs $i -models $models -attacks $attacks | Should -Be (((7 - $i) / 6) * $attacks * $models)
                }
            }
            It 'A natural roll of 1 is always a failure' {
                # I'm not convinced by this
                $bs1Hits = getHits -bs 1 -models $models -attacks $attacks
                $bs2Hits = getHits -bs 2 -models $models -attacks $attacks
                $bs1Hits | Should -Be $bs2Hits
            }
        }
        Context 'Validity checks' {
            It 'Does not accept stupid values for parameters' {
                { getHits -bs -4 -models $models -attacks $attacks } | Should -Throw
                { getHits -bs 'x' -models $models -attacks $attacks } | Should -Throw
                { getHits -bs $bs -models 'banana' -attacks $attacks } | Should -Throw
                { getHits -bs $bs -models 0 -attacks $attacks } | Should -Throw
                { getHits -bs $bs -models $models -attacks -50 } | Should -Throw
                { getHits -bs $bs -models $models -attacks 'twelve' } | Should -Throw
            }
        }
    }

    Describe 'Roll to wound' {
        Context 'Basic tests' {
            It 'Calculates basic scenarios correctly' {
                foreach ($s in (1..10)) {
                    foreach ($t in (1..10)) {
                        if ($s -eq $t) {
                            getWounds -hits $hits -s $s -t $t | Should -Be ($hits * (0.5))
                        }
                        elseif ($s -le (0.5 * $t)) {
                            getWounds -hits $hits -s $s -t $t | Should -Be ($hits * (1 / 6))
                        }
                        elseif ($s -lt $t) {
                            getWounds -hits $hits -s $s -t $t | Should -Be ($hits * (2 / 6))
                        }
                        elseif ($s -ge (2 * $t)) {
                            getWounds -hits $hits -s $s -t $t | Should -Be ($hits * (5 / 6))
                        }
                        elseif ($s -gt $t) {
                            getWounds -hits $hits -s $s -t $t | Should -Be ($hits * (4 / 6))
                        }
                        else {
                            throw 'Test is somehow doing impossible maths.'
                        }
                    }
                }
            }
        }
        Context 'Validity checks' {
            It 'Does not accept stupid values for parameters' {
                { getWounds -hits -4 -s $s -t $t } | Should -Throw
                { getWounds -hits 'x' -s $s -t $t } | Should -Throw
                { getWounds -hits $hits -s 'banana' -t $t } | Should -Throw
                { getWounds -hits $hits -s 0 -t $t } | Should -Throw
                { getWounds -hits $hits -s $s -t -50 } | Should -Throw
                { getWounds -hits $hits -s $s -t 'twelve' } | Should -Throw
            }
        }
    }

    Describe 'Roll to save' {
        Context 'Basic tests' {
            It 'Calculates basic scenarios correctly' {
                foreach ($ap in (0..6)) {
                    foreach ($save in (0..6)) {
                        foreach ($invulnerableSave in (0..6)) {
                            if ($save -eq 0 -and $invulnerableSave -eq 0) {
                                # No save
                                getUnsavedWounds -wounds $wounds -ap $ap -save $save -invulnerableSave $invulnerableSave | Should -Be $wounds
                            }
                            elseif ($invulnerableSave -gt 0 -and ($invulnerableSave -lt ($save + $ap) -or $save -eq 0)) {
                                # Invulnerable save is used
                                if ($invulnerableSave -eq 1) {
                                    getUnsavedWounds -wounds $wounds -ap $ap -save $save -invulnerableSave $invulnerableSave | Should -Be ($wounds * (1 / 6))
                                }
                                else {
                                    getUnsavedWounds -wounds $wounds -ap $ap -save $save -invulnerableSave $invulnerableSave | Should -Be ($wounds * (($invulnerableSave - 1) / 6))
                                }
                            }
                            else {
                                # Save is used
                                # Definitely not sure of this
                                if (($save + $ap) -eq 1) {
                                    # Natural 1s always fail
                                    getUnsavedWounds -wounds $wounds -ap $ap -save $save -invulnerableSave $invulnerableSave | Should -Be ($wounds * (1 / 6))
                                }
                                else {
                                    if ($save + $ap -gt 6) {
                                        getUnsavedWounds -wounds $wounds -ap $ap -save $save -invulnerableSave $invulnerableSave | Should -Be $wounds
                                    }
                                    else {
                                        getUnsavedWounds -wounds $wounds -ap $ap -save $save -invulnerableSave $invulnerableSave | Should -Be ($wounds * (($save + $ap -1) / 6))
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        Context 'Validity checks' {
            It 'Does not accept stupid values for parameters' {
                { getUnsavedWounds -wounds -4 -ap $ap -save $save -invulnerableSave $invulnerableSave } | Should -Throw
                { getUnsavedWounds -wounds 'x' -ap $ap -save $save -invulnerableSave $invulnerableSave } | Should -Throw
                { getUnsavedWounds -wounds $wounds -ap 'banana' -save $save -invulnerableSave $invulnerableSave } | Should -Throw
                { getUnsavedWounds -wounds $wounds -ap -50 -save $save -invulnerableSave $invulnerableSave } | Should -Throw
                { getUnsavedWounds -wounds $wounds -ap $ap -save 'twelve' -invulnerableSave $invulnerableSave } | Should -Throw
                { getUnsavedWounds -wounds $wounds -ap $ap -save -1 -invulnerableSave $invulnerableSave } | Should -Throw
                { getUnsavedWounds -wounds $wounds -ap $ap -save $save -invulnerableSave -8 } | Should -Throw
                { getUnsavedWounds -wounds $wounds -ap $ap -save $save -invulnerableSave 'pikachu' } | Should -Throw
            }
        }
    }

    Describe 'Roll for damage' {
        Context 'Basic tests' {
            It 'returns lower of unsavedWounds and targetModels when targetWounds is 1' {
                $res = getDamage -unsavedWounds $unsavedWounds -damage $damage -targetWounds 1 -targetModels $targetModels
                $res.totalDamage = [math]::min($unsavedWounds, $targetModels)
                $res.modelsDestroyed = [math]::min($unsavedWounds, $targetModels)
            }
            It 'destroys the target unit if the unsavedWounds >= targetModels and damage >= targetWounds' {
                $res = getDamage -unsavedWounds 5 -damage 2 -targetWounds 2 -targetModels 5
                $res.totalDamage = $targetModels * $targetWounds
                $res.modelsDestroyed = $targetModels
            }
            
        }
        Context 'Validity checks' {
            It 'Does not accept stupid values for parameters' {
                { getDamage -unsavedWounds -3 -damage $damage -targetWounds $targetWounds -targetModels $targetModels } | Should -Throw
                { getDamage -unsavedWounds 'all of them' -damage $damage -targetWounds $targetWounds -targetModels $targetModels } | Should -Throw
                { getDamage -unsavedWounds $unsavedWounds -damage -5 -targetWounds $targetWounds -targetModels $targetModels } | Should -Throw
                { getDamage -unsavedWounds $unsavedWounds -damage 'BOOM!' -targetWounds $targetWounds -targetModels $targetModels } | Should -Throw
                { getDamage -unsavedWounds $unsavedWounds -damage $damage -targetWounds 0 -targetModels $targetModels } | Should -Throw
                { getDamage -unsavedWounds $unsavedWounds -damage $damage -targetWounds 'Lots' -targetModels $targetModels } | Should -Throw
                { getDamage -unsavedWounds $unsavedWounds -damage $damage -targetWounds $targetWounds -targetModels 'a shitload' } | Should -Throw
                { getDamage -unsavedWounds $unsavedWounds -damage $damage -targetWounds $targetWounds -targetModels 500 } | Should -Throw
            }
        }
    }

    Describe 'Morale test' {
        Context 'Basic tests' {
            
        }
        Context 'Validity checks' {
            It 'Does not accept stupid values for parameters' {
                { getCravens -remainingModels 50 -destroyedModels $destroyedModels -leadership $leadership } | Should -Throw
                { getCravens -remainingModels -3 -destroyedModels $destroyedModels -leadership $leadership } | Should -Throw
                { getCravens -remainingModels $remainingModels -destroyedModels 100 -leadership $leadership } | Should -Throw
                { getCravens -remainingModels $remainingModels -destroyedModels 'all of them' -leadership $leadership } | Should -Throw
                { getCravens -remainingModels $remainingModels -destroyedModels $destroyedModels -leadership 0 } | Should -Throw
                { getCravens -remainingModels $remainingModels -destroyedModels $destroyedModels -leadership 'space marine' } | Should -Throw
            }
        }
    }
}