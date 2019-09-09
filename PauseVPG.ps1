#requires -RunAsAdministrator
<#
.SYNOPSIS
This script is designed to pause a VPG.
.DESCRIPTION
This script can be used to schedule a pausing of a VPG. Often used in conjuction with the UnPauseVPG script in a schedule.
.EXAMPLE
Examples of script execution
.VERSION
Applicable versions of Zerto Products script has been tested on. Unless specified, all scripts in repository will be 6.5u3 and later. If you have tested the script on multiple
versions of the Zerto product, specify them here. If this script is for a specific version or previous version of a Zerto product, note that here and specify that version
in the script filename. If possible, note the changes required for that specific version.
.LEGAL
Legal Disclaimer:
 
----------------------
This script is an example script and is not supported under any Zerto support program or service.
The author and Zerto further disclaim all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose.
 
In no event shall Zerto, its authors or anyone else involved in the creation, production or delivery of the scripts be liable for any damages whatsoever (including, without
limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or the inability
to use the sample scripts or documentation, even if the author or Zerto has been advised of the possibility of such damages. The entire risk arising out of the use or
performance of the sample scripts and documentation remains with you.
----------------------
#>

################################################
# Setting Cert Policy - required for successful auth with the Zerto API without connecting to vsphere using PowerCLI
################################################
add-type @"
 using System.Net;
 using System.Security.Cryptography.X509Certificates;
 public class TrustAllCertsPolicy : ICertificatePolicy {
 public bool CheckValidationResult(
 ServicePoint srvPoint, X509Certificate certificate,
 WebRequest request, int certificateProblem) {
 return true;
 }
 }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy


##PowerCLI requires remote signed execution policy - if this is not 
##enabled, it may be enabled here by uncommenting the line below.
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force

#PARAMETERS SECTION

#Configure the below variables first

$TheVpgName = "<VPG1>"

$strZVMIP = "<ZVMIP>" #Source site ZVM IP
$zvpPort = "9669"
$strZVMUser = "administrator" 
$strZVMPw = "password"

$BASEURL = "https://" + $strZVMIP + ":"+$zvpPort+"/v1/" #base URL for all APIs

##FUNCTIONS DEFINITIONS

#Authenticates with Zerto's APIs, Creates a Zerto api session and returns it, to be used in other APIs
function getZertoXSession (){
    #Authenticating with Zerto APIs
    $xZertoSessionURI = $BASEURL + "session/add"
    $authInfo = ("{0}:{1}" -f $strZVMUser,$strZVMPw)
    $authInfo = [System.Text.Encoding]::UTF8.GetBytes($authInfo)
    $authInfo = [System.Convert]::ToBase64String($authInfo)
    $headers = @{Authorization=("Basic {0}" -f $authInfo)}
    $xZertoSessionResponse = Invoke-WebRequest -Uri $xZertoSessionURI -Headers $headers -Method POST

    #Extracting x-zerto-session from the response, and adding it to the actual API
    $xZertoSession = $xZertoSessionResponse.headers.get_item("x-zerto-session")
    return $xZertoSession 
}

#Get a vpg identifier by invoking Zerto's APIs given a Zerto API session and a vpg name
function getVpgIdentifierByName ($vpgName){
    $url = $BASEURL + "vpgs"
    $response = Invoke-RestMethod -Uri $url -TimeoutSec 100 -Headers $zertSessionHeader -ContentType "application/json"
	    ForEach ($vpg in $response) {
      if ($vpg.VpgName -eq $vpgName){
            return $vpg.VpgIdentifier
        }
    }
}

#SCRIPT STARTS HERE - nothing to change beyond here but the logic is explained

$xZertoSession = getZertoXSession

$zertSessionHeader = @{"x-zerto-session"=$xZertoSession}

#Pause the VPG 
$vpgIdentifier1 = getVpgIdentifierByName $TheVpgName
$PauseVPGUrl = $BASEURL + "vpgs/" + $vpgIdentifier1 + "/pause"
Invoke-RestMethod -Uri $PauseVPGUrl -TimeoutSec 100 -Headers $zertSessionHeader -ContentType "application/json" -method POST
