# Azure Active Directory Graph Explorer PowerShell Module
The *GraphExplorer.psm1* PowerShell module allows you to authenticate against the Graph API using a **service principal** which is not possible with the online [Graph Explorer](https://graphexplorer.cloudapp.net/).


## Import the module
Download the above [GraphExplorer.psm1](https://github.com/whiteducksoftware/azure-graphexplorer/blob/master/GraphExplorer.psm1) module and import it using the [Import-Module](http://go.microsoft.com/fwlink/?LinkID=141553
) cmdlet: 
```powershell
Import-Module .\GraphExplorer.psm1
```

## List available cmdlets
Use the ```Get-Command``` cmdlet with the ```-Module``` parameter to get a list of all cmdlets in the module:
```powershell
Get-Command -Module GraphExplorer | Select-Object name
```

*Output:*
```
Name                          
----                          
Connect-GraphExplorer         
Get-GraphApplication          
Get-GraphContact              
Get-GraphDevice               
Get-GraphDirectoryRole        
Get-GraphDirectoryRoleTemplate
Get-GraphGroup                
Get-GraphOauth2PermissionGrant
Get-GraphServicePrincipal     
Get-GraphSubscribedSku        
Get-GraphTenantDetail         
Get-GraphUser    
```

## Connect-GraphExplorer
To initiate a connection to the Graph API, call the ```Connect-GraphExplorer``` cmdlet:

```powershell
Connect-GraphExplorer -Tenant 'yourTenant.onmicrosoft.com' -ClientId 'yourClientId' -ClientSecret 'yourSecret'
```

## Retrieve a resource
You can use the above cmdlets to retrieve the desired resources. All cmdlets also have an optional ```-ObjectId``` parameter which you can use to get a specific resource. E. g. retrieve all users:
```powershell
(Get-GraphUser).value | select objectId, userPrincipalName, userType
```
*Output:*
```
objectId                             userPrincipalName                             userType
--------                             -----------------                             --------
93b969e7-f72d-4a49-bdf0-88c6ed19a77f duck_whiteduck.de#EXT#@myaad.onmicrosoft.com  Guest   
5fe93869-b023-4b96-aff0-5b72f38f4f60 nick@myaad.onmicrosoft.com                    Member  
```
Retrieve a specific user:
```powershell
Get-GraphUser -ObjectId 5fe93869-b023-4b96-aff0-5b72f38f4f60 | select objectId, userPrincipalName, userType
```
*Output:*
```
objectId                             userPrincipalName                             userType
--------                             -----------------                             --------
5fe93869-b023-4b96-aff0-5b72f38f4f60 nick@myaad.onmicrosoft.com                    Member  
```
