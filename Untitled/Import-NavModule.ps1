function Import-NavModule
{
    param
    (
        [parameter(mandatory = $true)]
        [string]
        $Version
    )

    $modulePaths = @(
        "${env:ProgramFiles(x86)}\Microsoft Dynamics NAV\$Version\RoleTailored Client\Microsoft.Dynamics.Nav.Ide.psm1",
        "${env:ProgramFiles(x86)}\Microsoft Dynamics NAV\$Version\RoleTailored Client\Microsoft.Dynamics.Nav.Model.Tools.psd1",
        "${env:ProgramFiles(x86)}\Microsoft Dynamics NAV\$Version\RoleTailored Client\Microsoft.Dynamics.Nav.Apps.Tools.psd1",
        "${env:ProgramFiles(x86)}\Microsoft Dynamics NAV\$Version\RoleTailored Client\Microsoft.Dynamics.Nav.Apps.Management.psd1",
        "${env:ProgramFiles(x86)}\Microsoft Dynamics NAV\$Version\RoleTailored Client\Microsoft.Dynamics.Nav.Management.dll",
        "$env:ProgramFiles\Microsoft Dynamics NAV\$Version\Service\Microsoft.Dynamics.Nav.Apps.Management.psd1",
        "$env:ProgramFiles\Microsoft Dynamics NAV\$Version\Service\Microsoft.Dynamics.Nav.Management.dll"
    )
    
    # For some reason some modules (like Microsoft.Dynamics.Nav.Management) does not get imported if you run don't import twise.
    # 
    # NOTES:
    #
    #  * Before adding this line, I have found that only some NAV modules were imported and if you run the command multiple times
    #    it will import the missing modules. Same with first running the command, then waiting for a minute, and then running the
    #    command again - modules get imported but at least I needed to call Import-Module twise.
    #
    $modulePaths | ForEach-Object { Import-Module $_ -PassThru -WarningAction SilentlyContinue -ErrorAction SilentlyContinue } | Out-Null

    $importedModules = $modulePaths | ForEach-Object { Import-Module $_ -Global -PassThru }
  
    if (-not $importedModules)
    {
        Write-Error -Message "Could not import modules for NAV version $Version."
        Return
    }

    Write-Host "Successfully imported NAV modules."
    Write-Host "For a complete list of cmdlets type"
    Write-Host ""

    $importedModuleNames = $importedModules.Name | ForEach-Object `
    {
        if (' ' -notin $_)
        {
            $_
        }
        else
        {
            "'$_'"
        }
    }

    Write-Host "Get-Command -Module $($importedModuleNames -join ', ')" -ForegroundColor 'yellow'
}
