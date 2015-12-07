function Get-SqlServer
{
    Get-Service -Include 'MSSQL$*'
}
