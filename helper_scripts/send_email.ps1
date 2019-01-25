. ".\helper_scripts\k_constants.ps1"

function send_email($subject, $body) {
    $From = k_get_username
    $To = k_get_dest_email
    $SMTPServer = "smtp.outlook.com"
    $SMTPPort = "587"
    $sec_creds = create_secure_creds
    Send-MailMessage -From $From -to $To -Subject $subject -Body $body -SmtpServer $SMTPServer -port $SMTPPort -UseSsl -Credential $sec_creds
}

# # Testing Code
# function test_send() {
#     $test_subject = "Test subject"
#     $test_body = "Test Body so hello there"
#     send_email -subject $test_subject -body $test_body
# }

# test_send