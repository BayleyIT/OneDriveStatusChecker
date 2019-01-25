. ".\helper_scripts\k_constants.ps1"
. ".\helper_scripts\send_email.ps1"

function check_timing($path) {
    $cur_time = Get-Date -Format "HH:mm"
    $txt_content = Get-Content -Path $path
    $txt_time = Get-Date $txt_content -Format "HH:mm"
    $diff = ([datetime]$cur_time) - ([datetime]$txt_time)
    $max_diff = New-TimeSpan -Minutes 5

    if($diff -gt $max_diff) { return $true }
    else { return $false }
}

function check_other_txt_files() {
    $root_path = k_get_txt_drop_folder
    $txt_files = Get-ChildItem -Path $root_path

    foreach($file in $txt_files) {
        $check_path = "$root_path\$($file.Name)"
        Write-Host($check_path)
        $problem = check_timing -path $check_path

        if($problem -eq $true) {
            Remove-Item -Path $check_path -Force
            $subject = "NO CHECK IN - $file"
            $body = "Seems like there is an issue with: $file`nThe script likely isn't running or the server is off`n`n"
            $body += "Love,`nCloud Admin <3"
            send_email -body $body -subject $subject
        }
    }
}

# check_other_txt_files