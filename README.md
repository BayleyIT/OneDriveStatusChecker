# OneDriveStatusChecker

## Project Overview
- Runs on each VM - complete program is ran from "run.ps1"
- Each VM will need to have a scheduled task configured to run the script on startup
- Script runs ever 2 minutes
- Checks OneDrive Status
- If receiving bad error message - send email to IT support
    - FUTURE: If possible, drill down to exact file(and Job Folder) that is experiencing sync error
- For the time being - drops a TXT files on a shared network drive
    - Dropped TXT file contains Status, Check In time
- Checks other VM dropped TXT files - if a VM hasn't checked in for over 5 minutes - send email to IT Support
    - Flags the TXT file as checked
- Sleep for 2 minutes
