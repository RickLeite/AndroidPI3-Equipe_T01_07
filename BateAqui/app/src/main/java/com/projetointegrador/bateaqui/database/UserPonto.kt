package com.projetointegrador.bateaqui.database

import java.util.Date

data class UserPonto(
    val name: String,
    val email: String,
    val identifier: Int,
    val dateHour: Date
)