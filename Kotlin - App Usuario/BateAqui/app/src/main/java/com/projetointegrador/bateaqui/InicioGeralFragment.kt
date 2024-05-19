package com.projetointegrador.bateaqui

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.ImageView
import androidx.navigation.fragment.findNavController

class InicioGeralFragment : Fragment() {

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val view = inflater.inflate(R.layout.fragment_inicio_geral, container, false)

        // Configurar o click listener para o botão "Registrar Ponto" da tela inicial
        view.findViewById<Button>(R.id.botao_registrar_ponto).setOnClickListener {
            // Navegar para o fragmento RegistrarPontoFragment
            findNavController().navigate(R.id.action_inicioGeralFragment_to_registrarPontoFragment)
        }

        // Configurar o click listener para o botão "Calendario" da tela inicial
        view.findViewById<Button>(R.id.botao_calendario).setOnClickListener {
            // Navegar para o fragmento calendarioFragment
            findNavController().navigate(R.id.action_inicioGeralFragment_to_calendarioFragment2)
        }

        // Configurar o click listener para o botão "Relatório" da tela inicial
        view.findViewById<Button>(R.id.botao_relatorio).setOnClickListener {
            // Navegar para o fragmento relatorioFragment
            findNavController().navigate(R.id.action_inicioGeralFragment_to_relatorioFragment)
        }

        view.findViewById<Button>(R.id.botao_logout).setOnClickListener {
            // Navegar para o fragmento login
            findNavController().navigate(R.id.action_inicioGeralFragment_to_autenticacao)
        }

        return view
    }

}