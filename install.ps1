$PSScriptRoot | Get-ChildItem -Directory | ForEach-Object `
{
    $target = $_.FullName
    $link = "$home\Documents\WindowsPowerShell\Modules\$($_.Name)"
    if (-not (Test-Path $link))
    {
        cmd /c mklink /J $link $target
    }
}
