Install-Module PSScriptAnalyzer -Force

$rules = Get-ScriptAnalyzerRule
Describe 'PowerShell ScriptAnalyzer tests' {
    foreach ($rule in $rules) {
        It “passes the PSScriptAnalyzer Rule $rule“ {
            (Invoke-ScriptAnalyzer -Path '../MathsHammerHelper.psm1' -IncludeRule $rule.RuleName ).Count | Should Be 0
        }
    }
}
