package com.projetointegrador.bateaqui.database

import java.time.LocalTime
import java.util.Date



data class UserPonto(
    val name: String,
    val email: String,
    val identifier: String,
    val dateHour: Date
)


data class UserCalendario(
    val email: String?=null,
    val identifier: String?=null,
    val Horario_Entrada: String? =null,
    val Horario_Saida: String?=null,
    val Segunda: Boolean?=null,
    val Terça: Boolean?=null,
    val Quarta: Boolean?=null,
    val Quinta: Boolean?=null,
    val Sexta: Boolean?=null,
    val Sabado: Boolean?=null,
    val Entrada_AM_PM: String?=null,
    val Saida_AM_PM: String?=null
    )