package com.project.irhs.fragments

import android.app.AlertDialog
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ProgressBar
import android.widget.TextView
import android.widget.Toast
import androidx.fragment.app.Fragment
import com.google.firebase.database.*
import com.project.irhs.R
import com.project.irhs.databinding.FragmentHomeBinding
import kotlinx.coroutines.*
import java.net.HttpURLConnection
import java.net.URL
import java.text.SimpleDateFormat
import java.util.*

class HomeFragment : Fragment() {

    private lateinit var progressBar: ProgressBar
    private lateinit var progressText: TextView
    private val scope = CoroutineScope(Dispatchers.Main + Job())
    lateinit var binding: FragmentHomeBinding
    private lateinit var database: DatabaseReference

    private var previousWaterLevel: Float = 0f
    private var waterUsage: Float = 0f
    private var rainfall: Float = 0f
    private var isPumpAlertShown = false
    private var isTankWaterAlertShown = false

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        binding = FragmentHomeBinding.inflate(layoutInflater)

        progressBar = binding.circularProgressBar
        progressText = binding.progressText

        progressBar.visibility = View.VISIBLE
        progressText.text = "Loading..."

        initializeDatabaseListener()

        return binding.root
    }

    private fun initializeDatabaseListener() {
        database = FirebaseDatabase.getInstance().reference

        database.addValueEventListener(object : ValueEventListener {
            override fun onDataChange(snapshot: DataSnapshot) {
                try {
                    val ph_value = snapshot.child("Sensor/PH").value
                    val currentWaterLevel =
                        snapshot.child("Sensor/Distance").value?.toString()?.toFloatOrNull()
                    val moist = snapshot.child("Sensor/Moisture").value?.toString()?.toIntOrNull()
                    val rain = snapshot.child("Sensor/Rain").value?.toString()?.toIntOrNull()

                    val isRaining = rain != null && rain < 4000
                    binding.rain.text = if (isRaining) "Raining" else "Not Raining"

                    val isSoilDry = moist != null && moist >= 4000
                    binding.moist.text = if (isSoilDry) "Dry" else "Wet"

                    if (isSoilDry && !isPumpAlertShown) {
                        isPumpAlertShown = true
                        showAlert(
                            "Water Pump Alert",
                            "Soil is dry! The water pump has been turned ON."
                        ) {}
                    } else if (!isSoilDry) {
                        isPumpAlertShown = false
                    }

                    binding.phvalue.text = ph_value?.toString() ?: "N/A"
                    binding.progressText.text = currentWaterLevel?.toString() ?: "N/A"

                    if (currentWaterLevel != null) {
                        if (currentWaterLevel > 10 && !isTankWaterAlertShown) {
                            isTankWaterAlertShown = true
                            showAlert(
                                "Tank Water Alert",
                                "Water level is Low! Use household water."
                            ) {}
                        } else if (currentWaterLevel <= 10) {
                            isTankWaterAlertShown = false
                        }
                    }

                    if (currentWaterLevel != null) {
                        val waterLevelDifference = currentWaterLevel - previousWaterLevel
                        val isAdmin = arguments?.getBoolean("isAdmin", false) ?: false

                        if (isAdmin) { // Only allow admin to send data
                            if (rain != null && rain > 4000) {
                                waterUsage += waterLevelDifference
                                binding.wateringValue.text = "Water Usage: $waterUsage liters"
                                sendDataToPhpServer(waterUsage, "usage")
                            } else if (rain != null && rain <= 4000) {
                                rainfall += waterLevelDifference
                                binding.wateringValue.text = "Rainfall: $rainfall mm"
                                sendDataToPhpServer(rainfall, "rain")
                            }
                        }

                        previousWaterLevel = currentWaterLevel
                    }

                    val isPumpOn = isSoilDry
                    binding.wateringValue.text = if (isPumpOn) "Active" else "Disabled"

                    rain?.let {
                        binding.sunImg.setImageResource(
                            if (it >= 4000) R.drawable.rain else R.drawable.mazha
                        )
                        binding.lidImg.setImageResource(
                            if (it >= 4000) R.drawable.closelid else R.drawable.openlid
                        )
                    }

                    progressBar.visibility = View.GONE

                } catch (e: Exception) {
                    Log.e("FirebaseError", "Error fetching data: ${e.message}")
                    Toast.makeText(requireContext(), "Error loading data", Toast.LENGTH_SHORT)
                        .show()
                }
            }

            override fun onCancelled(error: DatabaseError) {
                progressBar.visibility = View.GONE
                Toast.makeText(
                    requireActivity(),
                    "Failed to read sensor data: ${error.message}",
                    Toast.LENGTH_SHORT
                ).show()
            }
        })
    }

    private fun sendDataToPhpServer(quantity: Float, type: String) {
        val currentDate = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault()).format(Date())
        val currentTime = SimpleDateFormat("HH:mm", Locale.getDefault()).format(Date())

        val jsonBody = """
            {
                "quantity": $quantity,
                "type": "$type",
                "date": "$currentDate",
                "time": "$currentTime"
            }
        """.trimIndent()

        scope.launch(Dispatchers.IO) {
            try {
                val url = URL("http://campus.sicsglobal.co.in/Project/rain_water/api/store_sensor_data.php")
                val connection = url.openConnection() as HttpURLConnection
                connection.requestMethod = "POST"
                connection.setRequestProperty("Content-Type", "application/json")
                connection.doOutput = true

                connection.outputStream.use { it.write(jsonBody.toByteArray()) }

                val responseCode = connection.responseCode
                if (responseCode == HttpURLConnection.HTTP_OK) {
                    Log.d("ServerResponse", "Data sent successfully")
                } else {
                    Log.e("ServerResponse", "Failed to send data: $responseCode")
                }
                connection.disconnect()
            } catch (e: Exception) {
                Log.e("HttpError", "Error sending data to PHP server: ${e.message}")
            }
        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        scope.cancel()
    }

    private fun showAlert(title: String, message: String, onDismiss: () -> Unit) {
        AlertDialog.Builder(requireContext())
            .setTitle(title)
            .setMessage(message)
            .setPositiveButton("OK") { dialog, _ ->
                onDismiss()
                dialog.dismiss()
            }
            .show()
    }
}
