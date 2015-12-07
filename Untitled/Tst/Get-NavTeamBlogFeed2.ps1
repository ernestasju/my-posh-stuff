# Get links to CU download pages

$feedUrl = 'https://blogs.msdn.microsoft.com/nav/feed/atom/'
[xml]$feedXml = Invoke-WebRequest $feedUrl

$cu = $feedXml.feed.entry | Where-Object { 'Announcements' -in $_.category.term -and 'Cumulative Updates' -in $_.category.term } `
                          | ForEach-Object {
                                [string]$html = Invoke-WebRequest $_.Id
                                $html -match 'KB (\d+)' | Out-Null
                                $kb = $Matches[1]
                                $p = [ordered]@{
                                    title = $_.title.InnerText
                                    #id    = $_.id
                                    #kb    = $kb
                                    hf    = "https://support.microsoft.com/en-us/hotfix/kbhotfix?kbnum=$kb&kbln=en-us&sd=mbs"
                                }
                                New-Object PSObject -Property $p
                          }
                          
$cu | Format-Table
