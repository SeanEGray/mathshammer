Import-Module "../MathshammerHelper.psm1"

# Some detaults
$bs = 3
$numModels = 10
$attacks = 2

Describe 'Roll to hit' {
    Context 'Basic tests' {
        It 'Calculates basic scenarios correclty' {
            foreach ($i in (2..6)) {
                getHits -bs $i -numModels $numModels -attacks $attacks | Should -Be (((7 - $i) / 6) * $attacks * $numModels)
            }
        }
        It 'A natural roll of 1 is always a failure' {
            # I'm not convinced by this
            $bs1Hits = getHits -bs 1 -numModels $numModels -attacks $attacks
            $bs2Hits = getHits -bs 2 -numModels $numModels -attacks $attacks
            $bs1Hits | Should -Be $bs2Hits
        }
    }
    Context 'Validity checks' {
        It 'Does not accept stupid values for parameters' {
            { getHits -bs -4 -numModels $numModels -attacks $attacks } | Should -Throw
            { getHits -bs 'x' -numModels $numModels -attacks $attacks } | Should -Throw
            { getHits -bs $bs -numModels 'banana' -attacks $attacks } | Should -Throw
            { getHits -bs $bs -numModels 0 -attacks $attacks } | Should -Throw
            { getHits -bs $bs -numModels $numModels -attacks -50 } | Should -Throw
            { getHits -bs $bs -numModels $numModels -attacks 'twelve' } | Should -Throw
        }
    }
}