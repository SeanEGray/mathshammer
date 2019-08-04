Install-Module PSScriptAnalyzer
#Invoke-ScriptAnalyzer 

Install-Module Pester -Force
Invoke-Pester -Script *.Tests.ps1 -OutputFormat NUnitXml -OutputFile 'TEST-HelperModule.xml'
