package com.projetointegrador.bateaqui.auth.util

data class FirebaseUserData(
    val uid: String?,
    val email: String?,
    val phoneNumber: String?,
    val displayName: String?,
    val photoUrl: String?,
    val isEmailVerified: Boolean?,
    val providerId: String?
)

