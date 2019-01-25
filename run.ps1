. ".\helper_scripts\k_constants.ps1"
. ".\helper_scripts\check_status.ps1"
. ".\helper_scripts\drop_txt.ps1"
. ".\helper_scripts\check_other_servers.ps1"
Unblock-File ".\helper_scripts\OneDriveLib.dll"
Import-Module ".\helper_scripts\OneDriveLib.dll"

function main($one_drive_root) {
    While($true) {
        check_on_onedrive -one_drive_root $one_drive_root
        drop_txt_file
        check_other_txt_files
        Start-Sleep -Seconds 120
    }
}

$one_drive_root = k_get_one_drive_root
main -one_drive_root $one_drive_root
Write-Host("Finished Running")