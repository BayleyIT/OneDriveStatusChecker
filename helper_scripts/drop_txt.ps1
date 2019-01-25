
. ".\helper_scripts\k_constants.ps1"
. ".\helper_scripts\send_email.ps1"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Drop Text File Section

function check_and_delete_existing($path) {
    if(Test-Path -path $path) { Remove-Item -Path $drop_path -Force }
}

function drop_txt_file() {
    # Folder Name: ServerName
    # Contents: Time
    $server_name = k_get_server_name
    $cur_time = (Get-Date -Format g).ToString()
    $drop_root_path = k_get_txt_drop_folder
    $drop_path = "$drop_root_path\$server_name.txt"
    #check for and delete exsist file
    check_and_delete_existing -path $drop_path

    #create txt file
    New-Item -Path $drop_path -ItemType "file" -Value $cur_time -Force
}

#test run
# drop_txt_file