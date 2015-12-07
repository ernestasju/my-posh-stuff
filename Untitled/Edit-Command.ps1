function Edit-Command
{
    param
    (
        $Name
    )

    $command = Get-Command -Name $Name
    if ($command.ScriptBlock -ne $null)
    {
        $file = Resolve-Path $command.ScriptBlock.File
        $startLine = $command.ScriptBlock.StartPosition.StartLine + 1
        $startColumn = $command.ScriptBlock.StartPosition.StartColumn + 1

        if ($psISE)
        {
            $fileTab = $psISE.CurrentPowerShellTab.Files.Add($file)
            $fileTab.Editor.SetCaretPosition($startLine, $startColumn)
        }
        else
        {
            ise -File "$file"
        }
    }
    else    
    {
        Throw 'This command cannot be edited.'
    }
}
