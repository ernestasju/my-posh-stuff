function HowTo-ConvertTenantToSingleTenantDb
{
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [String]$SourceServerInstance,
        [parameter(Mandatory=$true)]
        [String]$SourceTenantId
    )
    PROCESS
    {        
        $SourceTenant = Get-NAVTenant -ServerInstance $SourceServerInstance -Tenant $SourceTenantId
        $SourceApp = Get-NAVApplication -ServerInstance $SourceServerInstance
 
        Dismount-NAVTenant -ServerInstance $SourceServerInstance -Tenant $SourceTenantId -Force
        Export-NAVApplication -DatabaseServer $SourceApp.'Database server' -DatabaseName $SourceApp.'Database name' -DestinationDatabaseName $SourceTenant.DatabaseName -Force                   
    } 
}
