package com.example.projetointegrador

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.Button
import android.widget.Toast

class MainActivity : AppCompatActivity() {




    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)


        var Button: Button
        Button = findViewById(R.id.botao_registrar_ponto);


        Button.setOnClickListener(View.OnClickListener {

                val i = Intent(this,RegistrarPonto::class.java)
                startActivity(i)

        })
    }
}