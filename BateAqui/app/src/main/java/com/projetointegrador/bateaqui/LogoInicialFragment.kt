package com.projetointegrador.bateaqui

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.os.Handler
import android.os.Looper
import androidx.navigation.fragment.findNavController

class LogoInicialFragment : Fragment() {

    private val delayTimeLogo: Long = 2000 // 2 segundos
    private val handler = Handler(Looper.getMainLooper())

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val view = inflater.inflate(R.layout.fragment_logo_inicial, container, false)

        handler.postDelayed({
            findNavController().navigate(R.id.action_logoFragment_to_inicioGeralFragment)
        }, delayTimeLogo)

        return view
    }

    override fun onDestroyView() {

        handler.removeCallbacksAndMessages(null)
        super.onDestroyView()
    }
}