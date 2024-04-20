package com.projetointegrador.bateaqui

import android.content.ContentValues.TAG
import android.os.Bundle
import android.util.Log
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.TextView
import android.widget.Toast
import androidx.navigation.fragment.findNavController
import com.projetointegrador.bateaqui.database.FirestoreUtil
import com.projetointegrador.bateaqui.database.UserPonto
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Locale

class RegistroPontoFragment : Fragment() {

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val view = inflater.inflate(R.layout.fragment_registro_ponto, container, false)

        // botão Início
        setupBotaoInicio(view)

        // botão Registrar Ponto
        setupBotaoRegistrarPonto(view)

        // horário atual
        setupHorarioAtual(view)

        return view
    }


    private fun setupBotaoRegistrarPonto(view: View) {
        val botaoRegistrarPonto = view.findViewById<Button>(R.id.botao_registro_ponto)
        botaoRegistrarPonto.setOnClickListener {
            val name = "Name"
            val email = "Email"
            val identifier = 1815
            val dateHour = Calendar.getInstance().time

            val userPonto = UserPonto(name, email, identifier, dateHour)

            FirestoreUtil.addPonto(userPonto,
                onSuccess = { documentId ->
                    Log.d(TAG, "Ponto registrado com sucesso! Document ID: $documentId")
                    Toast.makeText(context, "Ponto registrado com sucesso!", Toast.LENGTH_SHORT).show()
                },
                onFailure = { e ->
                    Log.e(TAG, "Erro ao registrar ponto", e)
                    Toast.makeText(context, "Erro ao registrar ponto", Toast.LENGTH_SHORT).show()
                }
            )
        }
    }


    private fun setupBotaoInicio(view: View) {
        val botaoInicio = view.findViewById<Button>(R.id.botao_inicio)
        botaoInicio.setOnClickListener {
            findNavController().navigate(R.id.action_registrarPontoFragment_to_inicioGeralFragment)
        }
    }

    private fun setupHorarioAtual(view: View) {
        val textViewHoraDia = view.findViewById<TextView>(R.id.textViewHoraDia)
        val currentTime = Calendar.getInstance().time
        val dateFormat = SimpleDateFormat("EEEE      HH:mm:ss", Locale.getDefault())
        val formattedTime = dateFormat.format(currentTime)

        // Definir o horário atual no TextView
        textViewHoraDia.text = formattedTime
    }
}