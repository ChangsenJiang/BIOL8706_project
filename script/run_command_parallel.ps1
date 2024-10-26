# Define the path to the command file
Write-Host "Current working directory: $(Get-Location)"
$commandFilePath = "D:/BIOL8706_project/script/iqtree_commands.txt"

# Read each line from the command file
$commands = Get-Content $commandFilePath

# Start a background job for each command in the file
foreach ($cmd in $commands) {
    Start-Job -ScriptBlock { param($command, $path)
        Set-Location -Path $path/
        Invoke-Expression $command
    } -ArgumentList $cmd, "D:\BIOL8706_project\data\species_filter\example_species_filtered_400loci"
}

# Wait for all background jobs to complete
Get-Job | Wait-Job

# Collect and display output from all jobs
Get-Job | Receive-Job

# Clean up all jobs
Get-Job | Remove-Job