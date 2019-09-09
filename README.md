# Legal Disclaimer
This script is an example script and is not supported under any Zerto support program or service. The author and Zerto further disclaim all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose.

In no event shall Zerto, its authors or anyone else involved in the creation, production or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or the inability to use the sample scripts or documentation, even if the author or Zerto has been advised of the possibility of such damages. The entire risk arising out of the use or performance of the sample scripts and documentation remains with you.

# Pause/UnPause Scripts
These scripts are designed to allow you to pause or unpause a VPG and can be used with windows scheduler to automate this process.

# Getting Started
There are two versions of the script. Use PauseVPG.ps1 to pause the VPG in question, or UnPauseVPG.ps1 to unpause the VPG.

Set the variables below including the VPG name you would like pause/unpause. 

Schedule the script to run daily to keep the target VRAs balanced or run manually as required.

# Prerequisities
## Environment Requirements:
- PowerShell 5.0+

## In-Script Variables:
- ZVM IP / Port
- ZVM User / Password
- VPG Name

# Running Script
Once the necessary requirements have been completed select an appropriate host to run the script from. To run the script type the following from the directory the script is located in:

.\PauseVPG.ps1 or .\UnPauseVPG.ps1
