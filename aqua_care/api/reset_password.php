<?php
// ini_set('display_errors', 1);
// ini_set('display_startup_errors', 1);
// error_reporting(E_ALL);

require_once 'vendor/autoload.php';
require_once 'connection.php';

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

header('Content-Type: application/json');
date_default_timezone_set('Asia/Kolkata');

$response = [];

$email=$_REQUEST['email'];

    if ($email && filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $query = "SELECT userid FROM users WHERE email = ?";
        $stmt = $con->prepare($query);
        $stmt->bind_param("s", $email);
        $stmt->execute();
        $result = $stmt->get_result();

        if ($result->num_rows > 0) {
            $token = bin2hex(random_bytes(50));
            $expiry = date("Y-m-d H:i:s", strtotime('+1 hour'));

            $updateQuery = "UPDATE users SET reset_token = ?, token_expiry = ? WHERE email = ?";
            $updateStmt = $con->prepare($updateQuery);
            $updateStmt->bind_param("sss", $token, $expiry, $email);
            $updateStmt->execute();

            $resetLink = "http://campus.sicsglobal.co.in/Project/Aqua_farm/api/update_password_user.php?token=$token";

            $mail = new PHPMailer(true);
            try {
                $mail->isSMTP();
                $mail->Host = 'smtp.gmail.com';
                $mail->SMTPAuth = true;
                $mail->Username = 'eventcalendar980@gmail.com';
                $mail->Password = 'hsysrnimirigcgqz';
                $mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;
                $mail->Port = 587;

                $mail->setFrom('eventcalendar980@gmail.com', 'Aquacare App');
                $mail->addAddress($email);

                $mail->isHTML(true);
                $mail->Subject = 'Password Reset Request';
                $mail->Body = "
                    Hello,<br><br>
                    You have requested a password reset. Please click the link below to reset your password:<br><br>
                    <a href='$resetLink'>$resetLink</a><br><br>
                    If you did not request this, please ignore this email.<br><br>
                    Best regards,<br>
                    Aqua Care App Team
                ";
                $mail->AltBody = "You have requested a password reset. Visit this link: $resetLink";

                $mail->send();
                $response = [
                    'status' => 'success',
                    'message' => 'A password reset link has been sent to your email. Please check!'
                ];
            } catch (Exception $e) {
                $response = [
                    'status' => 'error',
                    'message' => 'Reset email could not be sent. Please try again later.'
                ];
            }
        } else {
            $response = [
                'status' => 'error',
                'message' => 'No user found with this email.'
            ];
        }
    } else {
        $response = [
            'status' => 'error',
            'message' => 'Invalid email address provided.'
        ];
    }


echo json_encode($response);
?>
