# Make sure you have installed the SharePoint Online PS and PnP module!
# Install-Module SharePointPnPPowerShellOnline
Start-Transcript
Import-Module Sharegate

.\Variables.ps1

# Get running tasks from ShareGate
$sessions = Find-CopySessions | Where-Object { $_.HasEnded -eq $False }
$runningTasks = $sessions.Count

if($runningTasks -ge $maxRunningTasks)
{
    Write-Host "$maxRunningTasks sessions running already! Skipping for a bit..."
}
else{
    Write-Host "$runningTasks/$maxRunningTasks sessions running. Starting..."
    $maxRunningTasks = $maxRunningTasks-$runningTasks

    $migrationSiteConnection = Connect-PnPOnline -Url $migrationSiteUrl -Credentials $credentialsMigrationTenant

    $camlQuery= "Your <camlQuery> to get the right items from the migration list (e.g: newly added items, finished items, items with errors etc)"

    $migrationItems = Get-PnPListItem -List $migrationListName -Connection $migrationSiteConnection -Query $camlQuery | Select-Object -first $maxRunningTasks

    if($migrationItems.count -gt 0) {
        foreach($migrationItem in $migrationItems)
        {
            # Note: When copying a team, make sure the 'title' corresponds to the displayname of a Team!
			$title = $migrationItem['Title']
            $id = $migrationItem['ID']

            # Note: The sourceUrl and destinationUrl are only needed for a Copy-Site task!
            $sourceUrl = $migrationItem['SourceUrl']
            $destinationUrl = $migrationItem['DestinationUrl']

            Write-Host "Starting $title job"
            
            # Start a Copy-Team, Copy-Site or incremental Copy-Site task
            #Start-Job -FilePath ".\Run-Copy-Site.ps1" -ArgumentList @($sourceUrl, $destinationUrl,$id)  -Name $title
            #Start-Job -FilePath ".\Run-Copy-Site.ps1" -ArgumentList @($sourceUrl, $destinationUrl,$id,$true)  -Name $title
            #Start-Job -FilePath ".\Run-Copy-Team.ps1" -ArgumentList @($title,$id)  -Name $title
        }
    }
    else{
        Write-Host "No more jobs to run"
    }
}

# This code block makes sure the PS session isn't terminated untill the jobs are done
# Thanks to: https://stackoverflow.com/questions/41977362/task-scheduling-and-powershells-start-job
$runningBackgroundJobs = Get-Job -State Running 
    while($runningBackgroundJobs.Count -gt 0){
    Start-Sleep -Seconds 1
    $runningBackgroundJobs = Get-Job -State Running
}
Stop-Transcript