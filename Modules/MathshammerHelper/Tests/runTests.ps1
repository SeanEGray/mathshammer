Install-Module PSScriptAnalyzer

$rules = Get-ScriptAnalyzerRule

Describe ‘PowerShell ScriptAnalyzer tests’ {
    foreach ($rule in $rules) {
        It “passes the PSScriptAnalyzer Rule $rule“ {
            (Invoke-ScriptAnalyzer -Path '../MathsHammerHelper.psm1' -IncludeRule $rule.RuleName ).Count | Should Be 0
        }
    }
}

Install-Module Pester -Force
Invoke-Pester -Script *.Tests.ps1 -OutputFormat NUnitXml -OutputFile 'TEST-HelperModule.xml'
