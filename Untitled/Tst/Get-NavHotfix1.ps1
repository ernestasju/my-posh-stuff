# Get cumulative update url

# todo: Get-url for the *latest* CU
$cuUrl = 'https://support.microsoft.com/en-us/hotfix/kbhotfix?kbnum=3106088&kbln=en-us&sd=mbs'

$ie = New-Object -ComObject 'InternetExplorer.Application'
#$ie.Visible = $true
$ie.Silent = $true
$ie.StatusBar = $true

$ie.Navigate($cuUrl)
while ($ie.ReadyState -ne 4) {
    Write-Progress -Activity 'Loading Hotfixes' -Status "IE Status: $($ie.StatusText) "
    Start-Sleep -Milliseconds 100
}
Write-Progress -Activity 'Loading Hotfixes' -Completed

$ie.Document.parentWindow.execScript('document.body.setAttribute("hfList",JSON.stringify(hfList))')

$hfList = $ie.Document.body.getAttribute('hfList') | ConvertFrom-Json

$hfList | Select-Object *, @{Name = 'url'; Expression = {
    $p = @{ 'x86' = 'i386' }
    "http://hotfixv4.microsoft.com/$($_.product)/$($_.release)/$($_.filename)/$($_.build)/free/$($_.fixid)_$($_.langcode)_$($p[$_.platform])_zip.exe" 
} } | Format-Table -Property *

$ie.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($ie) | out-null
Remove-Variable ie
