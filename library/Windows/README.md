# Powershell

download file
	Invoke-WebRequest -Uri $url -OutFile $output

start/stop service 
	sc stop AdvancedSystemCareService9
	sc start AdvancedSystemCareService9

Finding files
	Get-ChildItem -Path C:\ -Include *.key -Recurse



## PowerUp.ps1
	. .\PowerUp.ps1
	Invoke-AllChecks


## Vulns

### UNQUOTED SERVICE PATHS
   [i] When the path is not quoted (ex: C:\Program files\soft\new folder\exec.exe) Windows will try to execute first 'C:\Progam.exe', then 'C:\Program Files\soft\new.exe' and finally 'C:\Program Files\soft\new folder\exec.exe'. Try to create 'C:\Program Files\soft\new.exe'

### Token Impersonation
https://www.exploit-db.com/papers/42556
most commonly abused privileges:

SeImpersonatePrivilege
SeAssignPrimaryPrivilege
SeTcbPrivilege
SeBackupPrivilege
SeRestorePrivilege
SeCreateTokenPrivilege
SeLoadDriverPrivilege
SeTakeOwnershipPrivilege
SeDebugPrivilege

