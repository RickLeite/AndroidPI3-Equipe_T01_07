package com.projetointegrador.bateaqui.auth

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.core.view.isVisible
import androidx.navigation.fragment.findNavController
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.ktx.auth
import com.google.firebase.ktx.Firebase
import com.projetointegrador.bateaqui.R
import com.projetointegrador.bateaqui.databinding.FragmentCriarContaBinding

class CriarContaFragment : Fragment() {
    private var _binding: FragmentCriarContaBinding? = null
    private val binding get() = _binding!!
    private lateinit var auth: FirebaseAuth



    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentCriarContaBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        auth = Firebase.auth
        listener()
    }

    private fun listener(){
        binding.btnReturn.setOnClickListener {
            findNavController().popBackStack()
        }
        binding.btnCriarConta.setOnClickListener {
            val email = binding.edtEmail.text.toString().trim()
            val password = binding.edtSenha.text.toString().trim()
            binding.progressBar.isVisible=true
            criarNovaConta(email,password)

        }


    }

    private fun criarNovaConta(email:String, password:String){
        auth.createUserWithEmailAndPassword(email, password)
            .addOnCompleteListener { task ->
                if (task.isSuccessful) {
                    Toast.makeText(requireContext(),
                        "Nova conta criada com sucesso!",
                        Toast.LENGTH_SHORT)
                        .show()
                    binding.progressBar.isVisible=false
                    findNavController().navigate(R.id.action_global_inicioGeralFragment)

                } else {
                    Toast.makeText(requireContext(),
                        task.exception?.message,
                        Toast.LENGTH_SHORT)
                        .show()
                    binding.progressBar.isVisible=false
                }
            }
    }


    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}