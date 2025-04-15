package com.project.irhs.adapters

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.project.irhs.R
import com.project.irhs.login.model.LoginData

class UserAdapter(private val userList: List<LoginData>) :
    RecyclerView.Adapter<UserAdapter.UserViewHolder>() {

    class UserViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        val userName: TextView = itemView.findViewById(R.id.textUserName)
        val userEmail: TextView = itemView.findViewById(R.id.textUserEmail)
        val userPhone: TextView = itemView.findViewById(R.id.textUserPhone)
        val userId: TextView = itemView.findViewById(R.id.textUserId)

    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): UserViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.item_user, parent, false)
        return UserViewHolder(view)
    }

    override fun onBindViewHolder(holder: UserViewHolder, position: Int) {
        val user = userList[position]  // Get the current user
        holder.userName.text = user.first_name  // Use user.first_name instead of LoginData.first_name
        holder.userEmail.text = user.email
        holder.userPhone.text = user.phone
        holder.userId.text =user.userid
        // Use user.email instead of LoginData.email
    }

    override fun getItemCount(): Int = userList.size
}
