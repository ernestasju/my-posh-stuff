function Reload-Module($ModuleName)
{ 
    if((get-module -list | where{$_.name -eq "$ModuleName"} | measure-object).count -gt 0)
    {
     
        if((get-module -all | where{$_.Name -eq "$ModuleName"} | measure-object).count -gt 0)
        {
            rmo $ModuleName
            Write-Host "Module $ModuleName Unloading"
        }
     
        ipmo $ModuleName
        Write-Host "Module $ModuleName Loaded"
    }
    Else
    {
        Write-Host "Module $ModuleName Doesn't Exist"
    }
}

New-Alias -Name rlo -Value Reload-Module
