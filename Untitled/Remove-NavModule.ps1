function Remove-NavModule
{
    Remove-Module NavAdminTool -ErrorAction SilentlyContinue
    Remove-Module Microsoft.Dynamics.Nav.Apps.Tools -ErrorAction SilentlyContinue
    Remove-Module Microsoft.Dynamics.Nav.Ide.Tools -ErrorAction SilentlyContinue
    Remove-Module Microsoft.Dynamics.Nav.Model.Tools -ErrorAction SilentlyContinue
}
