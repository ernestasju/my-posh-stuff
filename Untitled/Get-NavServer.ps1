function Get-NavServer
{
    Get-Service -Include 'MicrosoftDynamicsNavServer$*'
}
