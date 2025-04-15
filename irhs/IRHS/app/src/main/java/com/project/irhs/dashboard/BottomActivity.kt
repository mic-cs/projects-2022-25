package com.project.irhs.dashboard

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import androidx.core.view.updatePadding
import androidx.fragment.app.Fragment
import com.project.irhs.R
import com.project.irhs.databinding.ActivityBottomBinding
import com.project.irhs.fragments.HomeContainerFragment
import com.project.irhs.fragments.MonitorFragment
import com.project.irhs.fragments.ProfileFragment

class BottomActivity : AppCompatActivity() {
    lateinit var binding: ActivityBottomBinding

    private val fragmentManager = supportFragmentManager
    private lateinit var homeContainerFragment: HomeContainerFragment
    private val monitorFragment = MonitorFragment()
    private val profileFragment = ProfileFragment()
    private var activeFragment: Fragment? = null

    private var isAdmin: Boolean = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityBottomBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // Handle insets for bottom navigation
        ViewCompat.setOnApplyWindowInsetsListener(binding.bottomNavigationView) { view, insets ->
            val systemBarsInsets = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            view.updatePadding(bottom = systemBarsInsets.bottom)
            insets
        }

        // Check if the user is admin
        isAdmin = checkIfUserIsAdmin()

        // Initialize Fragments
        homeContainerFragment = HomeContainerFragment()

        // Add fragments
        fragmentManager.beginTransaction().apply {
            add(R.id.dashBoardFrame, homeContainerFragment, "FragmentHome")
            add(R.id.dashBoardFrame, profileFragment, "FragmentProfile").hide(profileFragment)

            if (isAdmin) {
                add(R.id.dashBoardFrame, monitorFragment, "MonitorFragment").hide(monitorFragment)
            }
        }.commit()

        activeFragment = homeContainerFragment

        // Setup bottom navigation menu
        setupBottomNavigation()
    }

    private fun setupBottomNavigation() {
        val menu = binding.bottomNavigationView.menu

        // Remove monitor and view users for non-admin users
        if (!isAdmin) {
            menu.removeItem(R.id.monitor)
            menu.removeItem(R.id.view_users)
        }

        binding.bottomNavigationView.setOnItemSelectedListener {
            when (it.itemId) {
                R.id.home -> switchFragment(homeContainerFragment)
                R.id.profile -> switchFragment(profileFragment)
                R.id.monitor -> if (isAdmin) switchFragment(monitorFragment) else false
                else -> false
            }
        }
    }

    private fun switchFragment(fragment: Fragment): Boolean {
        activeFragment?.let {
            fragmentManager.beginTransaction().hide(it).show(fragment).commit()
        }
        activeFragment = fragment
        return true
    }

    private fun checkIfUserIsAdmin(): Boolean {
        val sharedPref = getSharedPreferences("UserPrefs", MODE_PRIVATE)
        val userRole = sharedPref.getString("user_role", "user")
        return userRole == "admin"
    }
}
