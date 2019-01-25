function k_get_username() { return "" }
function k_get_password() { return "" }
function k_get_dest_email() { return "" }
function k_get_one_drive_root() { return "" }
function k_get_server_name() { return "" }
function k_get_txt_drop_folder() { return "" }
function create_secure_creds() {
    $MyClearTextUsername = k_get_username
    $MyClearTextPassword = k_get_password

    $cred = ([pscredential]::new($MyClearTextUsername,(ConvertTo-SecureString -String $MyClearTextPassword -AsPlainText -Force)))

    return $cred
}