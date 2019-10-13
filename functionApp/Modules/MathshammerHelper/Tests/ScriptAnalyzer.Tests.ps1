Install-Module PSScriptAnalyzer -Force

$scripts = Get-ChildItem '../' -Filter '*.ps1' -Recurse | Where-Object {$_.name -NotMatch 'Tests.ps1'}
$rules = Get-ScriptAnalyzerRule
Describe 'PSSA Tests' {
    foreach ($script in $scripts) {
        Context "Testing $($script.Fullname)" {
            foreach ($rule in $rules) {
                It "passes the PSScriptAnalyzer Rule $rule" {
                    (Invoke-ScriptAnalyzer -Path $script.FullName -IncludeRule $rule.RuleName ).Count | Should Be 0
                }
            }
        }
    }
}
