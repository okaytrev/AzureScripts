###Azure AD bulk creation by CSV
###By: Trevar Hupf
###Require AzureAD module to be installed - http://mosshowto.blogspot.com/2019/08/create-user-azure-ad-powershell.html
###Require connect-AzureAd to desired tenant 

#sets logpath to current directory
$LogPath = $PSScriptRoot + "\log.txt"

#Logs date before each run
$currentdate = Get-Date 
Write-Output "--------This script ran on $currentdate ---------" | Out-File -Append -FilePath $LogPath

# Create a password object
$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile

#Store the data from ADUsers.csv in the $ADUsers variable 
$ADUsers = Import-csv "$PSScriptRoot\newusers.csv"

#Loop through each row containing user details in the CSV file 
foreach ($User in $ADUsers)
{
	#Read user data from each field in each row and assign the data to a variable as below	
	$displayname = $User.displayname
	$jobtitle 	= $User.jobtitle
	$department = $User.department
    $mailnickname     = $User.mailnickname
    $PasswordProfile.Password = "<Password>"
    
	#Check to see if the user already exists in AD
	 if (Get-AzureADUser -Filter "DisplayName eq '$displayname'")
	{
		 #If user does exist, give a warning
		 Write-Warning "A user account with username $Displayname already exist in Azure AD"
		 $displayname + " ********ALREADY EXISTS" | Out-File -Append -FilePath $LogPath
	}
	else
	{
		#Proceeds if user does not exist
        $fullmailnickname = "$mailnickname" + "@trevdomain.onmicrosoft.com"
        write-host = $fullmailnickname
		
        #User creation
		New-AzureadUser -AccountEnabled $true -DisplayName $displayname -UserPrincipalName $fullmailnickname  -Jobtitle $jobtitle -department $department -MailNickName $mailnickname -PasswordProfile $PasswordProfile 
            
		$displayname | Out-File -Append -FilePath $LogPath
	}
}
