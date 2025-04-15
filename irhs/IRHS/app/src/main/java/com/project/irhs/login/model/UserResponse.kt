package com.project.irhs.login.model

data class UserResponse(
    val status: Boolean,
    val data: List<LoginData>  // User list inside "data"
)
data class UserData(
    val userid: String,
    val first_name: String,
    val last_name: String,
    val email: String,
    val phone: String,
    val photo: String
)