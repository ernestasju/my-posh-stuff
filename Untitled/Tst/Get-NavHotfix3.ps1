function Get-NavHotfix3 {
    param (
        [string] $CUUrl
    )

    # What is the point of requesting the page anyway?! The important part is setting the session cookie.
    [string] $html = Invoke-WebRequest -Uri $CUUrl

    if ($html -match 'Read and accept the following agreement to continue.') {
        # Agreeing to the terms

        $session = New-Object Microsoft.PowerShell.Commands.WebRequestSession

        $cookie = New-Object System.Net.Cookie
        $cookie.Name = 'hotfixEulaCookie'
        $cookie.Value = '1'
        $cookie.Domain = 'support.microsoft.com'

        $session.Cookies.Add($cookie)

        [string] $html = Invoke-WebRequest -WebSession $session -Uri $cuUrl
    }

    $html -match 'hfList = (.*?);' | Out-Null

    $js = $Matches[1]

    $json = [regex]::Unescape($js) -replace '(\w+):','"$1":'

    $hfList = $json | ConvertFrom-Json

    $hfList | Select-Object *, @{Name = 'url'; Expression = {
        $p = @{ 'x86' = 'i386' }
        "http://hotfixv4.microsoft.com/$($_.product)/$($_.release)/$($_.filename)/$($_.build)/free/$($_.fixid)_$($_.langcode)_$($p[$_.platform])_zip.exe" 
    } }
}

#Get-NavHotfix3 'https://support.microsoft.com/en-us/hotfix/kbhotfix?kbnum=3106088&kbln=en-us&sd=mbs'
