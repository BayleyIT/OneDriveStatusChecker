# Unblock-File ".\helper_scripts\OneDriveLib.dll"
# # cd 'C:\Users\cloudadmin\Desktop\Status_Checker'
# Import-Module ".\helper_scripts\OneDriveLib.dll"
. ".\helper_scripts\send_email.ps1"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Generate Email Section

function generate_body($status) {
    #servername,status,checkinTime
    $cur_time = (Get-Date -Format g).ToString()
    $server_name = k_get_server_name
    $body = "Hey Good Looking,`n`nI'm seeing the following error message from onedrive:`n`n"
    $body += "Server: $server_name`nStatus: $status`nTime: $cur_time`n`n"
    $body += "Love,`nCloud Admin <3"
    
    return $body
}

function generate_subject() {
    $server_name = k_get_server_name
    $subject = "ERROR - $server_name"
    return $subject
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Check Status Section

function check_if_email_already_sent() {
    if(Test-Path -path ".\notification_drop\emailsent.txt") {
        return $false
    }
    else {
        $cur_time = (Get-Date -Format g).ToString()
        New-Item -Path ".\notification_drop\emailsent.txt" -Value $cur_time
        return $true
    }
}

function check_status($status) {
    if($status -eq "NotInstalled") {
        $should_i_send_email = check_if_email_already_sent
        if($should_i_send_email -eq $true) {
            $body = generate_body -status $status
            $subject = generate_subject
            send_email -body $body -subject $subject
        }
        return $false
    }
    else {
        return $true
    }
}

function get_one_drive_status($location) {
    $status = Get-ODStatus -ByPath $location -Verbose
    return $status
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Run Process Section

function grab_sub_folders_from_root($one_drive_root) {
    $folders = @()
    foreach($folder in Get-ChildItem $one_drive_root) {
        $folders += $folder.Name
    }
    return $folders
}

function check_on_onedrive($one_drive_root) {
    $onedrive_folders = grab_sub_folders_from_root -one_drive_root $one_drive_root
    $all_good = $true
    foreach($folder in $onedrive_folders) {
        $location = "$one_drive_root\$folder"
        $cur_status = get_one_drive_status -location $location
        Write-Host(" location: $location `n folder: $folder `n status: $cur_status `n")
        $all_good = check_status -status $cur_status

        if($all_good -eq $false) { break }
    }
    if ($all_good -eq $true) {
        if(Test-Path -path ".\notification_drop\emailsent.txt") {
            Remove-Item -Path ".\notification_drop\emailsent.txt" -Force
        }        
    }
}
