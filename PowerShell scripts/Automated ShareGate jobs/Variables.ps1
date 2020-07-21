

#================================================================================ Old tenant variables variables
$oldPassword = ConvertTo-SecureString "YourPasswordInPlainText" -AsPlainText -Force
$oldUser = "user@contoso.onmicrosoft.com"; 
$credentialsOldTenant = new-object -typename System.Management.Automation.PSCredential `
         -argumentlist $oldUser, $oldPassword
$oldTenantUrl = "https://contoso.sharepoint.com"
		 
#================================================================================ New tenant variables
$newPassword = ConvertTo-SecureString "YourPasswordInPlainText" -AsPlainText -Force
$newUser = "user@contoso.onmicrosoft.com"; 
$credentialsNewTenant = new-object -typename System.Management.Automation.PSCredential `
		 -argumentlist $newUser, $newPassword
$newTenantUrl = "https://contoso.sharepoint.com"

#================================================================================ Migration Site variables

$migrationSiteUrl = "https://contoso.sharepoint.com/sites/SiteWhereListIsHosted"
$migrationListName = "NameOfList"

# Credentials for the migration site (with the migration list)
$migrationPassword = ConvertTo-SecureString "YourPasswordInPlainText" -AsPlainText -Force
$migrationUser = "user@contoso.onmicrosoft.com"; 
$credentialsMigrationTenant = New-Object -TypeName System.Management.Automation.PSCredential 
			   -argumentlist $migrationUser,$migrationPassword;

#================================================================================ ShareGate/task specific variables
$maxRunningTasks = 3;
