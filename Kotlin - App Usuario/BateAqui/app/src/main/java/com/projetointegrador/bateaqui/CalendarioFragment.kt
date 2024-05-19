package com.projetointegrador.bateaqui

import android.content.ContentValues
import android.os.Bundle
import android.util.Log
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.EditText
import android.widget.Switch
import android.widget.Toast
import androidx.navigation.fragment.findNavController
import com.projetointegrador.bateaqui.auth.util.FirebaseAuthUtil
import com.projetointegrador.bateaqui.database.FirestoreUtil
import com.projetointegrador.bateaqui.database.UserCalendario
import com.projetointegrador.bateaqui.database.UserPonto


class CalendarioFragment : Fragment() {

    private var entrada: String? = null

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        val view = inflater.inflate(R.layout.fragment_calendario, container, false)


        // botão Início
        setupBotaoInicio(view)

        // botão relatorio
        setupBotaoRelatorio(view)

        // botão calendario
        setupBotaoConfirmarCalendario(view)

        return view
    }

    private fun setupBotaoConfirmarCalendario(view: View) {
        val botaoConfirmarCalendario = view.findViewById<Button>(R.id.botao_confirmar_calendario)
        botaoConfirmarCalendario.setOnClickListener {

            val H_entrada = view.findViewById<EditText>(R.id.HorarioEntrada)
            val H_saida = view.findViewById<EditText>(R.id.HorarioSaida)
            val switchSegunda = view.findViewById<Switch>(R.id.switch_segunda)
            val switchTerca = view.findViewById<Switch>(R.id.switch_terca)
            val switchQuarta = view.findViewById<Switch>(R.id.switch_quarta)
            val switchQuinta = view.findViewById<Switch>(R.id.switch_quinta)
            val switchSexta = view.findViewById<Switch>(R.id.switch_sexta)
            val switchSabado = view.findViewById<Switch>(R.id.switch_sabado)
            val switchEntrada = view.findViewById<Switch>(R.id.switch_entrda)
            val switchSaida = view.findViewById<Switch>(R.id.switch_saida)


            val currentUserData = FirebaseAuthUtil.getCurrentUserData()
            if (currentUserData != null) {
                val userCalendario = UserCalendario(
                    email = currentUserData.email ?: "No email",
                    identifier = currentUserData.uid ?: "No UID",
                    Horario_Entrada = H_entrada.text.toString(),
                    Horario_Saida = H_saida.text.toString(),
                    Segunda = switchSegunda.isChecked,
                    Terça = switchTerca.isChecked,
                    Quarta = switchQuarta.isChecked,
                    Quinta = switchQuinta.isChecked,
                    Sexta = switchSexta.isChecked,
                    Sabado = switchSabado.isChecked,
                    Entrada_AM_PM = if (switchEntrada.isChecked) "PM" else "AM",
                    Saida_AM_PM = if (switchSaida.isChecked) "PM" else "AM"
                )

                FirestoreUtil.addCalendario(userCalendario,
                    onSuccess = { documentId ->
                        Log.d(ContentValues.TAG, "Calendário salvo com sucesso! Document ID: $documentId")
                        Toast.makeText(context, "Calendário salvo com sucesso!", Toast.LENGTH_SHORT).show()
                    }
                ) { e ->
                    Log.e(ContentValues.TAG, "Erro ao salvar calendário", e)
                    Toast.makeText(context, "Erro ao salvar calendário", Toast.LENGTH_SHORT).show()
                }
            } else {
                Toast.makeText(context, "Usuário não autenticado", Toast.LENGTH_SHORT).show()
            }
        }
    }

    private fun setupBotaoInicio(view: View) {
        val botaoInicio = view.findViewById<Button>(R.id.botao_inicio)
        botaoInicio.setOnClickListener {
            findNavController().navigate(R.id.action_calendarioFragment2_to_inicioGeralFragment)
        }
    }

    private fun setupBotaoRelatorio(view: View) {
        val botaoRelatorio = view.findViewById<Button>(R.id.botao_relatorio)
        botaoRelatorio.setOnClickListener {
            findNavController().navigate(R.id.action_calendarioFragment2_to_relatorioFragment)
        }
    }

}