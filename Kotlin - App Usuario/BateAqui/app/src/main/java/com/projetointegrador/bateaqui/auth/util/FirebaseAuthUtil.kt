package com.projetointegrador.bateaqui.auth.util

import com.google.firebase.Firebase
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.auth

object FirebaseAuthUtil {
    private val auth: FirebaseAuth = Firebase.auth

    fun getCurrentUserData(): FirebaseUserData? {
        val currentUser = auth.currentUser
        return currentUser?.let {
            FirebaseUserData(
                uid = it.uid,
                email = it.email,
                phoneNumber = it.phoneNumber,
                displayName = it.displayName,
                photoUrl = it.photoUrl?.toString(),
                isEmailVerified = it.isEmailVerified,
                providerId = it.providerId,
            )
        }
    }
}