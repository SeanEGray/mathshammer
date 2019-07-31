Import-Module "$($env:Build_SourcesDirectory)/Modules/MathshammerHelper/MathshammerHelper.psd1"

# Some detaults
$bs = 3
$numModels = 10
$attacks = 2

Describe "Roll to hit" {
    Context "Basic tests" {
        It "A natural roll of 1 is always a failure" {
            # I'm not convinced by this
            $bs1Hits = getHits -bs 1 -numModels $numModels -attacks $attacks
            $bs2Hits = getHits -bs 2 -numModels $numModels -attacks $attacks
            $bs1Hits | Should -Be $bs2Hits
        }
    }
}