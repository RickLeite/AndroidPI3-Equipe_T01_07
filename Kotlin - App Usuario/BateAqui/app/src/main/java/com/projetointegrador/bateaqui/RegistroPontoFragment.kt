package com.projetointegrador.bateaqui

import android.Manifest
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.location.Location
import android.location.LocationManager
import android.os.Bundle
import android.provider.Settings
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.TextView
import android.widget.Toast
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.fragment.app.Fragment
import androidx.navigation.fragment.findNavController
import com.google.android.gms.location.*
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationServices
import com.projetointegrador.bateaqui.auth.util.FirebaseAuthUtil
import com.projetointegrador.bateaqui.database.FirestoreUtil
import com.projetointegrador.bateaqui.database.UserPonto
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Locale

class RegistroPontoFragment : Fragment() {

    private lateinit var fusedLocationProviderClient: FusedLocationProviderClient
    private lateinit var locationRequest: LocationRequest
    private lateinit var locationCallback: LocationCallback

    private val LOCATION_PERMISSION_REQUEST_CODE = 1

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val view = inflater.inflate(R.layout.fragment_registro_ponto, container, false)

        checkLocationSettings()
        fusedLocationProviderClient = LocationServices.getFusedLocationProviderClient(requireActivity())

        createLocationRequest()
        createLocationCallback()

        // Solicitar permissão de localização, se não for concedida
        if (ContextCompat.checkSelfPermission(
                requireContext(),
                Manifest.permission.ACCESS_FINE_LOCATION
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            requestLocationPermission()
        } else {
            // Iniciar as atualizações de localização apenas se a permissão estiver concedida
            startLocationUpdates()
        }

        // Configurações dos botões
        setupBotaoInicio(view)
        setupBotaoRegistrarPonto(view)
        setupHorarioAtual(view)
        setupBotaoRelatorio(view)

        return view
    }

    private fun requestLocationPermission() {
        requestPermissions(
            arrayOf(Manifest.permission.ACCESS_FINE_LOCATION),
            LOCATION_PERMISSION_REQUEST_CODE
        )
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)

        if (requestCode == LOCATION_PERMISSION_REQUEST_CODE) {
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                startLocationUpdates()
            } else {
                Toast.makeText(requireContext(), "Permissão de localização negada", Toast.LENGTH_SHORT).show()
            }
        }
    }

    private fun checkLocationSettings() {
        val locationManager = requireActivity().getSystemService(Context.LOCATION_SERVICE) as LocationManager
        if (!locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)) {
            // A localização não está ativada, redirecionar o usuário para as configurações de localização
            val settingsIntent = Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS)
            startActivity(settingsIntent)
        }
    }

    private fun createLocationRequest() {
        locationRequest = LocationRequest.create().apply {
            interval = 10000 // Intervalo de atualização de localização em milissegundos (10 segundos)
            fastestInterval = 5000 // Intervalo mais rápido de atualização de localização em milissegundos (5 segundos)
            priority = LocationRequest.PRIORITY_HIGH_ACCURACY
        }
    }

    private fun createLocationCallback() {
        locationCallback = object : LocationCallback() {
            override fun onLocationResult(locationResult: LocationResult) {
                locationResult ?: return
                for (location in locationResult.locations) {
                    // Process the new location here
                    val latitude = location.latitude
                    val longitude = location.longitude
                    Log.d(
                        "RegistroPontoFragment",
                        "New location - Latitude: $latitude, Longitude: $longitude"
                    )

                    // Verificar se está dentro da área permitida
                    if (isWithinAllowedArea(latitude, longitude)) {
                        // Está dentro do limite permitido, permitir o registro do ponto
                        // Seu código para registrar o ponto
                    } else {
                        // Se estiver fora da área permitida
                        Toast.makeText(
                            requireContext(),
                            "Fora da área permitida",
                            Toast.LENGTH_SHORT
                        ).show()
                    }
                }
            }
        }
    }

    private fun startLocationUpdates() {
        if (ActivityCompat.checkSelfPermission(
                requireContext(),
                Manifest.permission.ACCESS_FINE_LOCATION
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            return
        }
        fusedLocationProviderClient.requestLocationUpdates(
            locationRequest,
            locationCallback,
            null /* Looper */
        )
    }

    private fun stopLocationUpdates() {
        fusedLocationProviderClient.removeLocationUpdates(locationCallback)
    }

    override fun onPause() {
        super.onPause()
        stopLocationUpdates()
    }


    // Função para verificar se a localização está dentro da área permitida
    private fun isWithinAllowedArea(latitude: Double, longitude: Double): Boolean {
        // Coordenadas do centro da área permitida (substitua pelas coordenadas corretas)
        val centerLatitude = -22.834575
        val centerLongitude = -47.049426

        // Raio em metros (10 km ou outra distância)
        val allowedRadius = 1000.0  // 10 km

        // Calcular a distância entre a localização atual e o centro permitido
        val results = FloatArray(1)
        Location.distanceBetween(
            latitude,
            longitude,
            centerLatitude,
            centerLongitude,
            results
        )

        val distance = results[0]
        Log.d("RegistroPontoFragment", "Distância calculada: $distance metros")  // Debug para verificar a distância

        // Retornar se a distância está dentro do raio permitido
        return distance <= allowedRadius
    }

    private fun setupBotaoRegistrarPonto(view: View) {
        val botaoRegistrarPonto = view.findViewById<Button>(R.id.botao_registro_ponto)
        botaoRegistrarPonto.setOnClickListener {
            // Verificar se as permissões de localização estão concedidas
            if (ActivityCompat.checkSelfPermission(
                    requireContext(),  // Correção do contexto para fragment
                    Manifest.permission.ACCESS_FINE_LOCATION
                ) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(
                    requireContext(),
                    Manifest.permission.ACCESS_COARSE_LOCATION
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                requestLocationPermission()  // Solicitar permissão, se necessário
                return@setOnClickListener
            }

            // Se a permissão estiver concedida, obter a última localização
            fusedLocationProviderClient.getLastLocation()
                .addOnSuccessListener { location ->
                    if (location != null) {
                        val latitude = location.latitude
                        val longitude = location.longitude

                        // Verificar se está dentro da área permitida
                        if (isWithinAllowedArea(latitude, longitude)) {
                            // Está dentro do limite permitido, permitir o registro do ponto
                            // Seu código para registrar o ponto
                            val currentUserData = FirebaseAuthUtil.getCurrentUserData()
                            if (currentUserData != null) {
                                val userPonto = UserPonto(
                                    name = currentUserData.displayName ?: "Sem nome",
                                    email = currentUserData.email ?: "Sem email",
                                    identifier = currentUserData.uid ?: "Sem UID",
                                    dateHour = Calendar.getInstance().time
                                )

                                FirestoreUtil.addPonto(
                                    userPonto,
                                    onSuccess = { documentId ->
                                        Log.d("RegistroPontoFragment", "Ponto registrado com sucesso! Document ID: $documentId")
                                        Toast.makeText(
                                            requireContext(),
                                            "Ponto registrado com sucesso!",
                                            Toast.LENGTH_SHORT
                                        ).show()
                                    },
                                    onFailure = { e ->
                                        Log.e("RegistroPontoFragment", "Erro ao registrar ponto", e)
                                        Toast.makeText(
                                            requireContext(),
                                            "Erro ao registrar ponto",
                                            Toast.LENGTH_SHORT
                                        ).show()
                                    }
                                )
                            } else {
                                Toast.makeText(
                                    requireContext(),
                                    "Usuário não autenticado",
                                    Toast.LENGTH_SHORT
                                ).show()
                            }
                        } else {
                            // Se estiver fora da área permitida
                            Toast.makeText(
                                requireContext(),
                                "Fora da área permitida",
                                Toast.LENGTH_SHORT
                            ).show()
                        }
                    } else {
                        Toast.makeText(
                            requireContext(),
                            "Localização indisponível",
                            Toast.LENGTH_SHORT
                        ).show()
                    }
                }
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
        val dateFormat = SimpleDateFormat("EEEE HH:mm:ss", Locale("pt", "BR"))
        val formattedTime = dateFormat.format(currentTime)

        textViewHoraDia.text = formattedTime
    }

    private fun setupBotaoRelatorio(view: View) {
        val botaoRelatorio = view.findViewById<Button>(R.id.botao_relatorio)
        botaoRelatorio.setOnClickListener {
            findNavController().navigate(R.id.action_registrarPontoFragment_to_relatorioFragment)
        }
    }
}
