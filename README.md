# Active Directory Lingering Objects Cleanup

This PowerShell script detects and cleans up lingering objects in an Active Directory domain. It checks for lingering objects on all domain controllers in the current Active Directory domain and offers an optional `-CheckOnly` switch that allows you to check for lingering objects without removing them.

## Requirements

1. PowerShell 5.1 or later
2. Active Directory module for PowerShell
3. Administrator privileges to run the script

## Usage

1. Download the `LingeringObjectsCleanup.ps1` script from this repository.
2. Open a PowerShell console with administrator privileges.
3. Navigate to the directory where the script is saved.
4. Run the script with the desired mode:

   ### Check-Only Mode

   To check for lingering objects without removing them, run the following command:

   ```powershell
   .\LingeringObjectsCleanup.ps1 -CheckOnly
   ```
  
   ### Cleanup Mode

   To remove lingering objects from all domain controllers in the current Active Directory domain, run the following command:

   ```powershell
   .\LingeringObjectsCleanup.ps1
   ```


## Notes

- This script requires the Active Directory module for PowerShell to be installed. If the module is not installed, the script will attempt to import it.
- Make sure to run the script with administrator privileges, as it requires elevated permissions to perform the cleanup tasks.
