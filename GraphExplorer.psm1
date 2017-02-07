
function Connect-GraphExplorer
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [string]$Tenant,

        [Parameter(Mandatory=$true)]
        [guid]$ClientId,

        [Parameter(Mandatory=$true)]
        [string]$ClientSecret
    )

    Add-Type -AssemblyName System.Web
    $encodedClientId     = [System.Web.HttpUtility]::UrlEncode($ClientId)
    $encodedClientSecret = [System.Web.HttpUtility]::UrlEncode($ClientSecret)

    $invokeParameter = @{
        Body = "resource=https://graph.windows.net&client_id=$encodedClientId&client_secret=$encodedClientSecret&grant_type=client_credentials"
        Uri = "https://login.microsoftonline.com/$Tenant/oauth2/token"
        ContentType = "application/x-www-form-urlencoded"
        Method = 'Post'
    }

    $script:GraphApiTenant = $Tenant
    $script:GraphApiAccessToken =  Invoke-RestMethod @invokeParameter | select -expand access_token
}

function Invoke-GraphGetRequest
{
   [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [string]$Resource,

        [Parameter(Mandatory=$false)]
        [string]$ObjectId
    )

    if ([string]::IsNullOrEmpty($script:GraphApiTenant) -or [string]::IsNullOrEmpty($script:GraphApiAccessToken))
    {
        throw "You must call the Connect-GraphExplorer cmdlet before calling any other cmdlets."
    }

    $invokeParameter = @{
        Uri = "https://graph.windows.net/$script:GraphApiTenant/$Resource"
        Headers = @{Authorization = "Bearer $script:GraphApiAccessToken"}
    }

    if (-not [string]::IsNullOrEmpty($ObjectId))
    {
        $invokeParameter.Uri += "/$ObjectId"
    }

    $invokeParameter.Uri += "?api-version=1.6"
    
    Invoke-RestMethod @invokeParameter
}

function Invoke-GraphRequest
{
   [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [string]$UriPath,

        [Parameter(Mandatory=$true)]
        [ValidateSet('POST', 'GET', 'PUT', 'PATCH', 'DELETE')]
        [string]$Method
    )

    if ([string]::IsNullOrEmpty($script:GraphApiTenant) -or [string]::IsNullOrEmpty($script:GraphApiAccessToken))
    {
        throw "You must call the Connect-GraphExplorer cmdlet before calling any other cmdlets."
    }

    $invokeParameter = @{
        Uri = "https://graph.windows.net/$script:GraphApiTenant/$($UriPath.TrimStart('/'))"
        Headers = @{Authorization = "Bearer $script:GraphApiAccessToken"}
    }

    if ($invokeParameter.Uri -notmatch '\?api-version=')
    {
        $invokeParameter.Uri += "?api-version=1.6"
    }    
    
    Invoke-RestMethod @invokeParameter -Method $Method
}

function Get-GraphUser
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$false)]
        [string]$ObjectId
    )

    Invoke-GraphGetRequest -Resource 'users' -ObjectId $ObjectId
}

function Get-GraphApplication
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$false)]
        [string]$ObjectId
    )

    Invoke-GraphGetRequest -Resource 'applications' -ObjectId $ObjectId
}

function Get-GraphServicePrincipal
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$false)]
        [string]$ObjectId
    )

    Invoke-GraphGetRequest -Resource 'servicePrincipals' -ObjectId $ObjectId
}

function Get-GraphDevice
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$false)]
        [string]$ObjectId
    )

    Invoke-GraphGetRequest -Resource 'devices' -ObjectId $ObjectId
}

function Get-GraphGroup
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$false)]
        [string]$ObjectId
    )

    Invoke-GraphGetRequest -Resource 'groups' -ObjectId $ObjectId
}

function Get-GraphGroup
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$false)]
        [string]$ObjectId
    )

    Invoke-GraphGetRequest -Resource 'groups' -ObjectId $ObjectId
}

function Get-GraphContact
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$false)]
        [string]$ObjectId
    )

    Invoke-GraphGetRequest -Resource 'contacts' -ObjectId $ObjectId
}

function Get-GraphTenantDetail
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$false)]
        [string]$ObjectId
    )

    Invoke-GraphGetRequest -Resource 'tenantDetails' -ObjectId $ObjectId
}

function Get-GraphDirectoryRole
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$false)]
        [string]$ObjectId
    )

    Invoke-GraphGetRequest -Resource 'directoryRoles' -ObjectId $ObjectId
}

function Get-GraphDirectoryRoleTemplate
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$false)]
        [string]$ObjectId
    )

    Invoke-GraphGetRequest -Resource 'directoryRoleTemplates' -ObjectId $ObjectId
}

function Get-GraphOauth2PermissionGrant
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$false)]
        [string]$ObjectId
    )

    Invoke-GraphGetRequest -Resource 'oauth2PermissionGrants' -ObjectId $ObjectId
}

function Get-GraphSubscribedSku
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$false)]
        [string]$ObjectId
    )

    Invoke-GraphGetRequest -Resource 'subscribedSkus' -ObjectId $ObjectId
}


# export module members. 
Export-ModuleMember -function Connect-GraphExplorer
Export-ModuleMember -function Get-GraphUser
Export-ModuleMember -function Get-GraphApplication
Export-ModuleMember -function Get-GraphServicePrincipal
Export-ModuleMember -function Get-GraphDevice
Export-ModuleMember -function Get-GraphGroup
Export-ModuleMember -function Get-GraphContact
Export-ModuleMember -function Get-GraphTenantDetail
Export-ModuleMember -function Get-GraphDirectoryRole
Export-ModuleMember -function Get-GraphDirectoryRoleTemplate
Export-ModuleMember -function Get-GraphOauth2PermissionGrant
Export-ModuleMember -function Get-GraphSubscribedSku
Export-ModuleMember -function Invoke-GraphRequest