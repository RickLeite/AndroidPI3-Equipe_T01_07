package com.example.projetointegrador

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import android.widget.TextView
import java.text.SimpleDateFormat
import java.util.*

class RegistrarPonto : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_registrar_ponto)

        val textViewHoraDia = findViewById<TextView>(R.id.textViewHoraDia)

        // Obter a data e hora atuais
        val cal = Calendar.getInstance()
        val dateFormat = SimpleDateFormat("EEEE      HH:mm:ss", Locale.getDefault())
        val horaDiaAtual = dateFormat.format(cal.time)

        // Definir o texto do TextView com a hora e o dia atuais
        textViewHoraDia.text = horaDiaAtual

        var botao_inicio: Button
        botao_inicio = findViewById(R.id.botao_inicio)

        botao_inicio.setOnClickListener {
            this.finish()
        }

    }
}