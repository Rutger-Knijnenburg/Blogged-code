param
    (
	[Parameter(Position=0,Mandatory=$true)][string]$sourceUrl,
	[Parameter(Position=1,Mandatory=$true)][string]$destinationUrl,
    [Parameter(Position=2,Mandatory=$true)][string]$id,
	[Parameter(Position=3,Mandatory=$false)][switch]$incremental
    )

Import-Module Sharegate
.\Variables.ps1

try{
    Start-Transcript
	
	$sourceSite = Connect-Site -Url $sourceUrl -Credential $credentialsOldTenant
	$destinationSite = Connect-Site -Url $destinationUrl -Credential $credentialsNewTenant
					
	$migrationSiteConnection = Connect-PnPOnline -Url $migrationSiteUrl -Credentials $credentialsMigrationTenant
	$migrationItem = Set-PnPListmigrationItem -List $migrationListName -Identity $id -Connection $migrationSiteConnection -Values @{"Status"="Started";}
	
	if($incremental){
		$copysettings = New-CopySettings -OnContentItemExists IncrementalUpdate
		Copy-Site -Site $sourceSite -DestinationSite $destinationSite -Merge -Subsites -CopySettings $copysettings
	}
	else{
		Copy-Site -Site $sourceSite -DestinationSite $destinationSite -Merge -Subsites
	}

	$migrationItem = Set-PnPListmigrationItem -List $migrationListName -Identity $id -Connection $migrationSiteConnection -Values @{"Status"="Finished";}
	Stop-Transcript
}
Catch{
	
	$migrationItem = Set-PnPListmigrationItem -List $migrationListName -Identity $id -Connection $migrationSiteConnection -Values @{"Status"="Error";}
	Stop-Transcript
}