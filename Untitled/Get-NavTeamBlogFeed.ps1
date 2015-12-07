function Get-NavTeamBlogFeed4 {
    param (
        [string[]] $NAVVersions = $null
    )

    $feedUrl = 'https://blogs.msdn.microsoft.com/nav/feed/atom/'
    [xml]$feedXml = Invoke-WebRequest $feedUrl -UseBasicParsing

    $feedXml.feed.entry | Where-Object { 'Announcements' -in $_.category.term -and 'Cumulative Updates' -in $_.category.term } `
                        | ForEach-Object {
                            $_.title.InnerText -match 'Cumulative Update (\d+) for Microsoft Dynamics NAV (.*?) has been released' | Out-Null
                            $cuNumber = $Matches[1]
                            $navVersion = $Matches[2]
                            if ($NAVVersions -eq $null -or $navVersion -in $NavVersions) {
                                [string]$html = Invoke-WebRequest -UseBasicParsing $_.Id
                                $html -match 'KB (\d+)' | Out-Null
                                $kb = $Matches[1]
                                $p = [ordered]@{
                                    NAVVersion = $navVersion
                                    CUNumber   = $cuNumber
                                    KBArticle  = $kb
                                    HotfixUrl  = "https://support.microsoft.com/en-us/hotfix/kbhotfix?kbnum=$kb&kbln=en-us&sd=mbs"
                                }
                                New-Object PSObject -Property $p
                            }
                        }
}

#Get-NavTeamBlogFeed4
#Get-NavTeamBlogFeed4 -NAVVersions '2013','2013 R2'
