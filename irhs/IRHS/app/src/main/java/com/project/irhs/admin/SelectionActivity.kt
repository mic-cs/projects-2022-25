package com.project.irhs

    import android.content.Intent
    import android.os.Bundle
    import android.widget.Button
    import androidx.appcompat.app.AppCompatActivity
    import com.project.irhs.R
    import com.project.irhs.admin.AdminLoginActivity
    import com.project.irhs.login.LoginActivity

class SelectionActivity : AppCompatActivity() {
        override fun onCreate(savedInstanceState: Bundle?) {
            super.onCreate(savedInstanceState)
            setContentView(R.layout.activity_selection) // Make sure this XML exists

            // Find buttons from the layout
            val btnAdmin = findViewById<Button>(R.id.btnAdmin)
            val btnUser = findViewById<Button>(R.id.btnUser)

            // Handle Admin button click
            btnAdmin.setOnClickListener {
                val intent = Intent(this, AdminLoginActivity::class.java)
                startActivity(intent)
            }

            // Handle User button click
            btnUser.setOnClickListener {
                val intent = Intent(this, LoginActivity::class.java)
                startActivity(intent)
            }
        }
    }
