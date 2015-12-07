function prompt
{
    Write-Host 'PS ' -NoNewLine
    $currentLocation = (Get-Location).Path
    Write-Host $currentLocation -ForegroundColor Gray -NoNewLine
    if ($currentLocation.Length -le ((Get-Host).UI.RawUI.BufferSize.Width - 50))
    {
        Write-Host ' ' -NoNewLine
    }
    else
    {
        Write-Host ''
    }
    '$ '
}

New-PSDrive -Name PS -PSProvider FileSystem -Root C:\!PS -ErrorAction SilentlyContinue | Out-Null
