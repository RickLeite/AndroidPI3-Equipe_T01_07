package com.projetointegrador.bateaqui.auth

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.core.view.isVisible
import androidx.navigation.fragment.findNavController
import com.google.firebase.Firebase
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.auth
import com.projetointegrador.bateaqui.R
import com.projetointegrador.bateaqui.databinding.FragmentCriarContaBinding
import com.projetointegrador.bateaqui.databinding.FragmentRecuperarContaBinding

class RecuperarContaFragment : Fragment() {
    private var _binding: FragmentRecuperarContaBinding? = null
    private val binding get() = _binding!!
    private lateinit var auth: FirebaseAuth

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        _binding = FragmentRecuperarContaBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        auth = Firebase.auth
        listener()
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null // Limpar a referência para evitar memory leaks
    }

    private fun listener(){
        binding.btnEnviar.setOnClickListener {
            val email = binding.emailRecuperar.text.toString().trim()
            recuperarConta(email)
        }
    }

    private fun recuperarConta(email:String){
        auth.sendPasswordResetEmail(email)
            .addOnCompleteListener { task ->
                if (task.isSuccessful) {
                    Toast.makeText(requireContext(),
                        "Email enviado com sucesso",
                        Toast.LENGTH_SHORT)
                        .show()

                } else {
                    Toast.makeText(requireContext(),
                        task.exception?.message,
                        Toast.LENGTH_SHORT)
                        .show()
                }
            }
    }
}

