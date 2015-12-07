function Get-NavTeamBlogFeed3 {
    $feedUrl = 'https://blogs.msdn.microsoft.com/nav/feed/atom/'
    [xml]$feedXml = Invoke-WebRequest $feedUrl

    $feedXml.feed.entry | Where-Object { 'Announcements' -in $_.category.term -and 'Cumulative Updates' -in $_.category.term } `
                        | ForEach-Object {
                            $_.title.InnerText -match 'Cumulative Update (\d+) for Microsoft Dynamics NAV (.*?) has been released' | Out-Null
                            $cuNumber = $Matches[1]
                            $navVersion = $Matches[2]
                            [string]$html = Invoke-WebRequest $_.Id
                            $html -match 'KB (\d+)' | Out-Null
                            $kb = $Matches[1]
                            $p = [ordered]@{
                                nav = $navVersion
                                cu  = $cuNumber
                                kb  = $kb
                                hf  = "https://support.microsoft.com/en-us/hotfix/kbhotfix?kbnum=$kb&kbln=en-us&sd=mbs"
                            }
                            New-Object PSObject -Property $p
                        }
}
