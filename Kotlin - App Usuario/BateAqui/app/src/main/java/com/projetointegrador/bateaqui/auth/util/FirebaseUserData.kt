package com.projetointegrador.bateaqui.auth.util

import java.time.LocalTime

data class FirebaseUserData(
    val uid: String?,
    val email: String?,
    val phoneNumber: String?,
    val displayName: String?,
    val photoUrl: String?,
    val isEmailVerified: Boolean?,
    val providerId: String?,
    val Horario_Entrada: String? =null,
    val Horario_Saida: String? =null,
    val Segunda: Boolean? =null,
    val Terça: Boolean? =null,
    val Quarta: Boolean? =null,
    val Quinta: Boolean? =null,
    val Sexta: Boolean? =null,
    val Sabado: Boolean? =null,
)

