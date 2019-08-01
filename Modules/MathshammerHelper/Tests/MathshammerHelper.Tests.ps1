Import-Module "../MathshammerHelper.psm1"

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
                        elseif ($invulnerableSave -gt 0 -and $invulnerableSave -lt ($save + $ap)) {
                            # Invulnerable save is used
                            getUnsavedWounds -wounds $wounds -ap $ap -save $save -invulnerableSave $invulnerableSave | Should -Be ($wounds * ((7 - $invulnerableSave) / 6))
                        }
                        else {
                            # Save is used
                            getUnsavedWounds -wounds $wounds -ap $ap -save $save -invulnerableSave $invulnerableSave | Should -Be ($wounds * ((7 - ($save + $ap) / 6)))
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