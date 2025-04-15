package com.project.irhs.fragments

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.project.irhs.R
import com.project.irhs.adapters.UserAdapter
import com.project.irhs.api.APIInterface
import com.project.irhs.login.model.LoginData // Corrected import
import com.project.irhs.login.model.UserResponse
import retrofit2.*
import retrofit2.converter.gson.GsonConverterFactory

class ViewUsersFragment : Fragment() {

    private lateinit var recyclerView: RecyclerView
    private lateinit var adapter: UserAdapter

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val view = inflater.inflate(R.layout.fragment_view_users, container, false)

        recyclerView = view.findViewById(R.id.recyclerView)
        recyclerView.layoutManager = LinearLayoutManager(requireContext())

        fetchUsers()

        return view
    }

    private fun fetchUsers() {
        val retrofit = Retrofit.Builder()
            .baseUrl("http://campus.sicsglobal.co.in/Project/rain_water/api/")
            .addConverterFactory(GsonConverterFactory.create())
            .build()

        val apiInterface = retrofit.create(APIInterface::class.java)

        apiInterface.getUsers().enqueue(object : Callback<UserResponse> {
            override fun onResponse(
                call: Call<
                        UserResponse>, response: Response<UserResponse>
            ) {
                if (response.isSuccessful && response.body() != null) {
                    val users = response.body()?.data ?: emptyList()  // ✅ Extract the "data" field
                    adapter = UserAdapter(users)
                    recyclerView.adapter = adapter
                } else {
                    println("Error: ${response.errorBody()?.string()}")
                }
            }

            override fun onFailure(call: Call<UserResponse>, t: Throwable) {
                println("Network Failure: ${t.message}")
            }
        })
    }

}

