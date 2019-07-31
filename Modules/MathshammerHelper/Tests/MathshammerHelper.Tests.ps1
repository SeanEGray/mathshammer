Import-Module "../MathshammerHelper.psm1"

# Some detaults
$bs = 3
$models = 10
$attacks = 2
$hits = 10
$s = 4
$t = 4

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
            
        }
    }
}