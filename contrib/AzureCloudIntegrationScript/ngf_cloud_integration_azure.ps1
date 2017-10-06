#
# Script.ps1
#
# This script uploads a certificate to Azure
# and creates an Azure Rm Role For use with the UDR updating via the load balancers.
# Written by Jeremy MacDonald
#-----Variables
$ADAppName = 'NGF';  #String used to hold App Name for Azure Back End, Can always be NGF;
$validNumDays = 730; #2 years long, Azure Standard, and needs to match expdate of cert.
$pathToCERfile;      #String used to hold file path;
$resourceGroupName;  #String used to hold Reource Group that the firewalls are contained in;
$subcriptionID;      #Sting used to hold Subcription ID of Azure Account.
$identifier;         #String containing Azure RM AD identifier.
$rolename;           #String containing Azure RM AD Role name;
$role;               #Custom role object for NGF Cloud Intergration.
$firewallRole;       #Role object for NGF.
$endDate;            #Ending date for the uploaded certificate.
$prince;             #Certificate to be uploaded to Azure for role verification.
$cred;               #Holds login infomation in a secure variable.
$loginResult         #Stores the Login result informaion (USER ID, ACCOUND ID ect).
$exitData            #Stores all data needed to be saved after completion. of program.
#-----End Variables

#-----Functions

#----- Greets people upon load.
function Greeting
{
clear;
Write-Host "*****************************************************************************"
Write-Host "Welcome to Azure-Certificate Development"
Write-Host "This script will create the needed certificates and Azure Service object for"
Write-Host "HA-Fail over on the NG Firewall."
Write-Host "Written by Jeremy MacDonald 9/25/2017"
Write-Host "*****************************************************************************"
Write-Host " "
}
#-----Gets and checks for the existance of the Certificate File (Arm.cer)
function CheckCERFile
{
	$exist = 0; 	#Variable to check if file exists, set to does not exist.
	while (!$exist)
{
	Write-Host "Input certificate location and name."; 
	$pathToCERfile = Read-Host("Typically C:\path\arm.cer") #Prompts user to enter patch and name of cert file.
	$exist = [System.IO.File]::Exists($pathToCERfile);
	if (! $exist) #Check if certificate exists and loop on error.
		{
		 Write-Host "File was not found @ $pathToCERfile, please ensure correct path." -ForegroundColor Yellow;
		}
	else
		{
		 Write-Host "File was found @ $pathToCERfile, continuing." -ForegroundColor Green;
		}
}

	return $pathToCERfile;
}
#----- Gets Reource Group from user and verifies its existance.
function GetResourceGroup
{
#-----Can display all know Resource Groups if requested.
    $exists = $FALSE;
	$groupname = Read-Host("Please enter Resource group name");
	Get-AzureRmResourceGroup -Name $groupname -ev exists -ea 0;
	while ($exists)
	{
    $RGList = Get-AzureRmResourceGroup;
    Write-Host("Group not found. Please try again.")-ForegroundColor Yellow;
    Write-Host("Show List of Resource Groups? y/n")-ForegroundColor White;
    $bool = Read-Host;
    if($bool -eq 'y') #---- If desired dispalys all known Resoure Groups.
    {
        Foreach ($i in $RGList)
        {
            Write-Host $i.ResourceGroupName;
        }
    }
	$groupname = Read-Host("Please enter Resource group name.");
	Get-AzureRmResourceGroup -Name $groupname -ev exists -ea 0;
	}
	Write-Host("Resource group $groupname found. Continuing.")-Foregroundcolor green;
	return $groupname; #----- Returns correct Resource Group name as String.
}
#----- Gets Azure Application value from user and verifies its existance.
function GetAzureRmAppId
{
	$valid=$FALSE;
    $temp=Get-AzureRmADApplication; #---temp list of Azure Rm Applications (and their id's)
	while (! $valid)
	{
        $valid=$TRUE;
        Write-Host ("Please enter a unique Azure Rm Ad App Id (homepage) for this service: ");
        Write-Host ("Example: http://localhost:xxxx");
        $name = Read-Host;
        while($name -eq '')
        {
            Write-Host ("Please enter the Azure Rm Ad App Id (Cannot be blank): ")-ForegroundColor Yellow;
            $name = Read-Host;
        }

        ForEach ($i in $temp)
        {

            if ($i.HomePage -eq $name -or $i.IdentifierUris -eq $name)
            {
                $valid=$FALSE;
                write-host ("Duplicate name found!")-ForegroundColor Yellow;
            }
        }
        if (!$valid)
            {
                write-Host "Display known HomePage/Uri Names? y/n";
                $a=Read-Host;
                if($a -eq 'y')
                {
                    ForEach ($i in $temp)
                    {
                        if ($i.HomePage -eq $name -or $i.IdentifierUris -eq $name)
                        {
                            write-host $i.HomePage -ForegroundColor Yellow;
                            write-host $i.$i.IdentifierUris -ForegroundColor Yellow;
                        }
                        else
                        {
                            write-host $i.HomePage -ForegroundColor White;
                            write-host $i.$i.IdentifierUris -ForegroundColor white;
                        }
                    }
                }
            }
        }
Write-Host ("Name is unique! Continuing")-ForegroundColor Green;
return $name;
}
#----- Gets AzureAppRole Name from user and verifies it is unique.
function GetAzureApplicationRoleName
{
    $valid = $FALSE;
    $temp=Get-AzureRmRoleDefinition;
    while(! $valid)
    {
        Write-Host "Please enter a -unique- Azure Application Role Name"
        $name=Read-Host;
         while($name -eq '')
        {
            Write-Host ("Please enter Azure Application Role Name( Cannot be blank): ")-ForegroundColor Yellow;
            $name = Read-Host;
        }

        $valid=$TRUE;
        ForEach ($i in $temp)
        {
            if ($i.name -eq $name)
            {
                $valid=$FALSE;
                write-host ("Duplicate name found!")-ForegroundColor Yellow;
            }
        }
           if (!$valid)
           {
                write-Host "Display known Role Names? y/n";
                $a=Read-Host;
                if($a -eq 'y')
                {
                    ForEach ($i in $temp)
                    {
                        write-host $i.name;
                    }
                    Write-Host " ";
                }
            }
    }
    Write-Host ("Name is unique! Continuing")-ForegroundColor Green;
    return $name;
}
#----- Generates the End day for the uploaded certificate
function Generate_EndDate
{
	Param($validNumDays);
	Write-Host ("Generation of Certificate end date started...");
	Write-Host ("");
	$endDate = [System.DateTime]::Parse((date).ToString("yyyy.MM.dd"));
    $timespan = New-TimeSpan -Days $validNumDays;
    $endDate = $endDate + $timespan;
  	Write-Host ("...Generation of Certificate end date completed")-ForegroundColor Green;
	return $endDate;
}
#----- Generates new Azure Rm Service Princial
function Upload_Prince
{
	param($firewallRole,$prince);
	
	try
{
	
}
catch
{
	"An error occured!";
}
}
#----- Leaves program after successful resolution
function Leave_Script
{
    Param ($subcriptionID,$identifier,$resourceGroupName,$loginResult,$newRole);

    write-host("Sensitive data is about to be displayed. Press return when ready.");
    Read-Host(" ");
    Write-Host("Please save the following for later use in the NG deployment.");
    write-Host("Subscription ID: ", $subcriptionID);
    Write-Host("Login result: ", $loginResult.Account);
    Write-Host("ApplicationID: ", $identifier);
    write-host("Resoure Group: ", $resourceGroupName);
    Write-Host("Role Created: ",$newRole);
	Read-Host("Press Return to exit");
}
#----- End of Functions

############################
#Main program starts here. #
############################

#-----Greeting
Greeting;
#------Login to Azure
#------Login is done here and not in a function, as it seems the login creds are lost after the data is returned. Seems to be a bug on Azure end.
$successful=$FALSE; #Sets succeful to false for while loop.
while(!$successful) # Repeats until user is able to log into Azure correctly.
{
$successful = $TRUE; # successful is now true unless otherwise found to be false inside the loop.
    try #try to login to Azure error if unable able to login.
    {
        $loginResult=Login-AzureRmAccount -ErrorVariable err -ErrorAction Stop;
    }
    catch #catch login error and prompt for another attempt.
    {
        $successful=$FALSE;
        Write-Host ("It appears that we were unable to login properly. Please Try again.")-ForegroundColor Yellow;
    }
}
write-host ("Meow: ", $loginResult);
#-----Check for certificate file (Arm.cer)
$pathToCERfile = CheckCERFile;
#-----Set Subscription to default subscription for the current login. Exit on error (no subscription found)
try
{
$subcriptionID = (Get-AzureRmContext -ErrorVariable err -ErrorAction Stop).Subscription.SubscriptionId;
}
catch
{
Write-Host ($err);
exit;
}# If there is no SubscriptionId script exit.

#-----Set Azure RM Subscription.
Write-Host("Setting current Azure Rm Subscription...");
try
{
$azureSubscription = Select-AzureRmSubscription -SubscriptionId $subcriptionID -ErrorVariable err -ErrorAction Stop;
}
catch
{
Write-Host ("*** WARNING!***")-ForegroundColor Yellow;
Write-Host ("There was an error selecting subsciption ID, one may not exist with this account.")-ForegroundColor Yellow;
if (!$subcriptionID)
{
Write-Host ("Subscription ID returned result: NULL")-ForegroundColor Yellow;
}
else
{
Write-Host ("Subscription ID returned result:",$subcriptionID)-ForegroundColor Yellow;
}
Write-Host ("This is an unrecoverable error. Exiting Script") -ForegroundColor Red;
#Break;
}# If there is no SubscriptionId scrip exits.
Write-Host("Azure subscription found and set as: $subscriptionID.")
Write-Host("...setting current Azure subscription Completed.")-ForegroundColor Green;
#-----Get Reource Group Name;
$resourceGroupName = GetResourceGroup;
#-----Get Reource Application Identifier;
$identifier = GetAzureRmAppId;
#-----Get Reource Application Name;
$rolename = GetAzureApplicationRoleName;

# Create a custom role for NGF Cloud Integration. An existing role is cloned, all rights removed and then assigned proper privileges
write-Host ("Role Generation Started...");
#---Generates a Azure Role Definition and assigns approperiate values.
$role = Get-AzureRmRoleDefinition "Virtual Machine Contributor"
$role.Id = $null
$role.Name = $roleName
$role.Description = "Barracuda NextGen Firewall Cloud Integration"
$role.Actions.Clear()
# Add role definitions to the empty role 
$role.Actions.Add("Microsoft.Compute/virtualMachines/*")
$role.Actions.Add("Microsoft.Network/*")
$role.AssignableScopes.Clear()
$role.AssignableScopes.Add("/subscriptions/"+$subcriptionID.ToString());
#-----

#----- Converts teh role definttion to legitimate role object.
$firewallRole = New-AzureRmRoleDefinition -Role $role

#-----Certificate Generation
$endDate= Generate_EndDate($validNumDays); #-----Expire date for certificate.
#-----Generates certificate and pulls key from certificate.
$cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate($pathToCERfile)
$key = [System.Convert]::ToBase64String($cert.GetRawCertData())

#---Creating Princial account for use in Azure.
Write-Host ("Generation of Principal account started...");
$app = New-AzureRmADApplication -DisplayName $ADAppName -HomePage $identifier.ToString() -IdentifierUris $identifier -CertValue $key -EndDate $endDate;
$prince = New-AzureRmADServicePrincipal -ApplicationId $app.ApplicationId
Write-Host ("...Generation of Principal account completed")-ForegroundColor Green;

# Wait for Azure to generate service principal
Write-Host("Sleeping for 35 seconds while Azure generates new service principal remotely.")
Start-Sleep -Seconds 35;
Write-Host("...Sleeping completed.")
#Upload Service Principal
write-host("Generating Service Principal for Azure.");
$newRole=New-AzureRmRoleAssignment -RoleDefinitionName $firewallRole.Name -ServicePrincipalName $prince.ServicePrincipalNames[0]
write-host("Generating Service Pricipal Completed.")-ForegroundColor Green;
#-----Exit Successfuly
write-host ("**NOTICE**")-ForegroundColor Yellow;
write-host ("Sensitive data about to be displayed to screen press enter when ready.")-ForegroundColor Yellow;
write-host ("**NOTICE**")-ForegroundColor Yellow;
read-host;
write-host ("Please save the below data for later use in NG deployment.");
write-host ("Subscription ID:");
write-host (Get-AzureRmContext).Subscription.SubscriptionId -ForegroundColor Green;
write-host ("Tenant ID:");
write-host (Get-AzureRmContext).Tenant.TenantId -ForegroundColor Green;
write-host ("Application ID:");
write-host ($app.ApplicationId) -ForegroundColor Green;
write-host ("Group name:");
write-host ($resourceGroupName) -ForegroundColor Green;