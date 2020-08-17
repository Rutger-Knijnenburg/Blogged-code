param
    (
    [Parameter(Position=0,Mandatory=$true)][string]$title,
    [Parameter(Position=1,Mandatory=$true)][string]$id
    )

Import-Module Sharegate

.\Variables.ps1

try{
    Start-Transcript
	
	$sourceTenant = Connect-Tenant -Domain $oldTenantUrl -Credential $credentialsOldTenant

	$team =  Get-Team -Name $title -Tenant $sourceTenant
	
	$destinationTenant = Connect-Tenant -Domain $newTenantUrl -Credential $credentialsNewTenant

	$migrationSiteConnection = Connect-PnPOnline -Url $migrationSiteUrl -Credentials $credentialsMigrationTenant
	$migrationItem = Set-PnPListItem -List $migrationListName -Identity $id -Connection $migrationSiteConnection -Values @{"Status"="Started";}

	Copy-Team -Team $team -DestinationTenant $destinationTenant

	$migrationItem = Set-PnPListItem -List $migrationListName -Identity $id -Connection $migrationSiteConnection -Values @{"Status"="Finished";}
	Stop-Transcript
}
Catch{
	
	$migrationItem = Set-PnPListItem -List $migrationListName -Identity $id -Connection $migrationSiteConnection -Values @{"Status"="Error";}
	Stop-Transcript
}