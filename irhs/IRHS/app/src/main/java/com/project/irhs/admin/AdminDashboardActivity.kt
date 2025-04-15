package com.project.irhs.admin

import android.content.Intent
import android.os.Bundle
import android.view.Menu
import android.view.MenuItem
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.widget.Toolbar
import androidx.fragment.app.Fragment
import com.google.android.material.bottomnavigation.BottomNavigationView
import com.project.irhs.R
import com.project.irhs.SelectionActivity
import com.project.irhs.fragments.HomeFragment
import com.project.irhs.fragments.MonitorFragment
import com.project.irhs.fragments.SettingsFragment
import com.project.irhs.fragments.ViewUsersFragment

class AdminDashboardActivity : AppCompatActivity() {

    private lateinit var bottomNavigationView: BottomNavigationView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_admin_dashboard)

        // Set up Toolbar
        val toolbar = findViewById<Toolbar>(R.id.admin_toolbar)
        setSupportActionBar(toolbar)

        bottomNavigationView = findViewById(R.id.bottom_navigation)

        // Remove profile menu item if it exists
        bottomNavigationView.menu.findItem(R.id.profile)?.isVisible = false

        // Load Home Fragment by default
        if (savedInstanceState == null) {
            loadFragment(HomeFragment())
        }

        // Handle Bottom Navigation Item Clicks
        bottomNavigationView.setOnItemSelectedListener { item ->
            val fragment = when (item.itemId) {
                R.id.home -> HomeFragment()
                R.id.monitor -> MonitorFragment()
                R.id.view_users -> ViewUsersFragment()
                R.id.settings -> SettingsFragment()
                else -> null
            }

            fragment?.let {
                loadFragment(it)
                true
            } ?: false
        }
    }

    // Inflate the logout menu
    override fun onCreateOptionsMenu(menu: Menu?): Boolean {
        menuInflater.inflate(R.menu.admin_dashboard_menu, menu)
        return true
    }

    // Handle Logout Click
    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        return when (item.itemId) {
            R.id.action_logout -> {
                Toast.makeText(this, "Logging Out...", Toast.LENGTH_SHORT).show()
                val intent = Intent(this, SelectionActivity::class.java)
                intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
                startActivity(intent)
                true
            }
            else -> super.onOptionsItemSelected(item)
        }
    }

    private fun loadFragment(fragment: Fragment) {
        supportFragmentManager.beginTransaction()
            .replace(R.id.fragment_container, fragment)
            .commit()
    }
}
