<?php 
include("connection.php");

$alert_message = '';
$alert_type = '';

if (!isset($_GET['token']) || empty($_GET['token'])) {
    $alert_message = "Invalid or missing reset token.";
    $alert_type = "danger";
} else {
    $token = $_GET['token'];

    if ($_SERVER['REQUEST_METHOD'] == 'POST') {
        $newPassword = $_POST['password'];
        $confirmPassword = $_POST['confirm_password'];

        // Validate password length and confirmation
        if (strlen($newPassword) < 6 || strlen($newPassword) > 8) {
            $alert_message = "Password must be between 6 and 8 characters long.";
            $alert_type = "danger";
        } elseif (!preg_match('/[A-Z]/', $newPassword)) {
            $alert_message = "Password must contain at least one uppercase letter.";
            $alert_type = "danger";
        } elseif (!preg_match('/[^A-Za-z0-9]/', $newPassword)) {
            $alert_message = "Password must contain at least one special character.";
            $alert_type = "danger";
        } elseif ($newPassword !== $confirmPassword) {
            $alert_message = "Passwords do not match.";
            $alert_type = "danger";
        } else {
            // Check if token is valid and not expired
            $stmt = $con->prepare("SELECT * FROM users WHERE reset_token = ? AND token_expiry > NOW()");
            $stmt->bind_param("s", $token);
            $stmt->execute();
            $result = $stmt->get_result();

            if ($result->num_rows > 0) {
                // Token is valid and not expired, proceed to update password
                $stmt = $con->prepare("UPDATE users SET password = ?, reset_token = NULL, token_expiry = NULL WHERE reset_token = ?");
                $stmt->bind_param("ss", $newPassword, $token);
                $stmt->execute();

                if ($stmt->affected_rows > 0) {
                    $alert_message = "Your password has been updated successfully.";
                    $alert_type = "success";
                }
            } else {
                $alert_message = "The reset link is invalid or has expired.";
                $alert_type = "danger";
            }
            $stmt->close();
        }
    }
}

$con->close();
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Password</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .position-relative .eye-icon {
            position: absolute;
            right: 10px;
            top: 60%; /* Adjusted to align more centrally */
            transform: translateY(-50%);
            cursor: pointer;
            font-size: 1.25em;
            color: #333;
        }

        .mb-3.position-relative {
            padding-bottom: 20px; /* Adjusted to ensure no overlap */
        }

        .footer {
            background-color: #f8f9fa;
            padding-top: 20px;
            padding-bottom:10px;
            text-align: center;
            margin-top:50px;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="navbar navbar-expand-lg navbar-light bg-light shadow-sm">
    <div class="container d-flex justify-content-center align-items-center">
        <img src="logo-transparent-png.png" style="width: 400px;" alt="Logo">
    </div>
</header>

    <!-- Update Password Section -->
    <section class="ftco-section contact-section">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-12 mb-4 text-center">
                    <h3 class="h3" style="margin:20px; color:gray;">Update Password</h3>
                </div>
            </div>
            <div class="row justify-content-center align-items-center min-vh-90">
                <div class="col-md-5 col-sm-12">
                    <div class="card border-0 shadow-lg">
                        <div class="row g-0">
                            <div class="col-md-12 p-5">
                                <form action="update_password_user.php?token=<?php echo htmlspecialchars($token ?? ''); ?>" method="post">
                                    <?php
                                    if (!empty($alert_message)) {
                                        echo '<div class="alert alert-' . $alert_type . ' alert-dismissible fade show" role="alert">
                                                ' . $alert_message . '
                                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                              </div>';
                                    }
                                    ?>
                                    <div class="mb-3 position-relative">
                                        <label for="password" class="form-label">New Password</label>
                                        <input type="password" class="form-control" id="password" name="password" placeholder="Enter your new password" required>
                                        <span id="togglePassword" class="eye-icon">👁️</span>
                                    </div>
                                    <div class="mb-3 position-relative">
                                        <label for="confirm_password" class="form-label">Confirm Password</label>
                                        <input type="password" class="form-control" id="confirm_password" name="confirm_password" placeholder="Confirm your new password" required>
                                        <span id="toggleConfirmPassword" class="eye-icon">👁️</span>
                                    </div>
                                    <div class="form-group">
                                        <input type="submit" value="Update Password" class="btn btn-primary w-100" style="background-color:forestgreen; border:green;">
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <small class="mb-0">&copy; 2024 Rain Sensing App. All Rights Reserved.</small>
        </div>
    </footer>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Toggle password visibility
        const togglePassword = document.querySelector('#togglePassword');
        const passwordField = document.querySelector('#password');
        const toggleConfirmPassword = document.querySelector('#toggleConfirmPassword');
        const confirmPasswordField = document.querySelector('#confirm_password');

        togglePassword.addEventListener('click', function () {
            const type = passwordField.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordField.setAttribute('type', type);
            this.textContent = type === 'password' ? '👁️' : '🙈';
        });

        toggleConfirmPassword.addEventListener('click', function () {
            const type = confirmPasswordField.getAttribute('type') === 'password' ? 'text' : 'password';
            confirmPasswordField.setAttribute('type', type);
            this.textContent = type === 'password' ? '👁️' : '🙈';
        });
    </script>
</body>
</html>
