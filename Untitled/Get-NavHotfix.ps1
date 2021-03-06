function Get-NavHotfix4 {
    param (
        [string] $CUUrl 
    )

    # Agreeing to the terms
    $session = New-Object Microsoft.PowerShell.Commands.WebRequestSession

    $cookie = New-Object System.Net.Cookie
    $cookie.Name = 'hotfixEulaCookie'
    $cookie.Value = '1'
    $cookie.Domain = 'support.microsoft.com'

    $session.Cookies.Add($cookie)

    [string] $html = Invoke-WebRequest -WebSession $session -Uri $cuUrl -UseBasicParsing

    $html -match 'hfList = (.*?);' | Out-Null

    $js = $Matches[1]

    $json = [regex]::Unescape($js) -replace '([a-z]+):','"$1":'

    $hfList = $json | ConvertFrom-Json

    $hfList | Select-Object *, @{Name = 'url'; Expression = {
        $p = @{ 'x86' = 'i386' }
        "http://hotfixv4.microsoft.com/$($_.product)/$($_.release)/$($_.filename)/$($_.build)/free/$($_.fixid)_$($_.langcode)_$($p[$_.platform])_zip.exe" 
    } }
}

#Get-NavHotfix4 'https://support.microsoft.com/en-us/hotfix/kbhotfix?kbnum=3106088&kbln=en-us&sd=mbs'
