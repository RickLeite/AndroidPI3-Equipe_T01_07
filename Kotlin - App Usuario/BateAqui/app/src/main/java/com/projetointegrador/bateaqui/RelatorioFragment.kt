package com.projetointegrador.bateaqui

import android.app.DatePickerDialog
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.DatePicker
import android.widget.TextView
import androidx.fragment.app.Fragment
import androidx.navigation.fragment.findNavController
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.firebase.firestore.FirebaseFirestore
import com.projetointegrador.bateaqui.auth.util.FirebaseAuthUtil
import com.projetointegrador.bateaqui.database.UserPonto
import java.text.SimpleDateFormat
import java.util.*
import java.util.concurrent.TimeUnit

class RelatorioFragment : Fragment() {

    private lateinit var selectedDateTextView: TextView
    private lateinit var pontosMarcadosRecyclerView: RecyclerView
    private lateinit var pontosMarcadosAdapter: PontosMarcadosAdapter
    private lateinit var horasTrabalhadasTextView: TextView
    private lateinit var firestore: FirebaseFirestore
    private var selectedDate: Date? = null


    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val view = inflater.inflate(R.layout.fragment_relatorio, container, false)
        horasTrabalhadasTextView = view.findViewById(R.id.textTotalHorasTrabalhadas)
        selectedDateTextView = view.findViewById(R.id.textSelectedDate)
        pontosMarcadosRecyclerView = view.findViewById(R.id.recyclerViewPontosMarcados)
        pontosMarcadosAdapter = PontosMarcadosAdapter(listOf())
        pontosMarcadosRecyclerView.layoutManager = LinearLayoutManager(requireContext())
        pontosMarcadosRecyclerView.adapter = pontosMarcadosAdapter
        val btnDatePicker: Button = view.findViewById(R.id.btnDatePicker)
        val btnGerarRelatorio: Button = view.findViewById(R.id.botao_gerarRelatorio)
        firestore = FirebaseFirestore.getInstance()

        setupBotaoInicio(view)

        btnDatePicker.setOnClickListener {
            showDatePickerDialog()
        }

        btnGerarRelatorio.setOnClickListener {
            selectedDate?.let { fetchDataFromFirestore(it) }
        }

        return view
    }

    private fun showDatePickerDialog() {
        val calendar = Calendar.getInstance()
        val year = calendar.get(Calendar.YEAR)
        val month = calendar.get(Calendar.MONTH)
        val day = calendar.get(Calendar.DAY_OF_MONTH)

        val datePickerDialog = DatePickerDialog(
            requireContext(),
            DatePickerDialog.OnDateSetListener { _, selectedYear, selectedMonth, selectedDay ->
                val selectedDateCalendar = Calendar.getInstance()
                selectedDateCalendar.set(selectedYear, selectedMonth, selectedDay)
                selectedDate = selectedDateCalendar.time
                updateSelectedDate(selectedDate!!)
            },
            year,
            month,
            day
        )

        datePickerDialog.show()
    }

    private fun updateSelectedDate(date: Date) {
        val dateFormat = SimpleDateFormat("dd/MM/yyyy", Locale.getDefault())
        val selectedDateString = dateFormat.format(date)
        selectedDateTextView.text = "Data Selecionada: $selectedDateString"
    }

    private fun fetchDataFromFirestore(selectedDate: Date) {
        val calendar = Calendar.getInstance()
        calendar.time = selectedDate
        calendar.set(Calendar.HOUR_OF_DAY, 0)
        calendar.set(Calendar.MINUTE, 0)
        calendar.set(Calendar.SECOND, 0)
        val startOfDay = calendar.time

        calendar.add(Calendar.DAY_OF_MONTH, 1)
        val endOfDay = calendar.time

        val currentUserData = FirebaseAuthUtil.getCurrentUserData()

        firestore.collection("user_pontos")
            .whereGreaterThanOrEqualTo("dateHour", startOfDay)
            .whereLessThan("dateHour", endOfDay)
            .whereEqualTo("identifier", currentUserData?.uid)
            .get()
            .addOnSuccessListener { documents ->
                val dateHoursList = mutableListOf<Date>()
                val dateHoursStringList = mutableListOf<String>()
                for (document in documents) {
                    val dateHour = document.getDate("dateHour")
                    dateHour?.let {
                        dateHoursList.add(it)
                        val formattedHour = SimpleDateFormat("HH:mm:ss", Locale.getDefault()).format(it)
                        dateHoursStringList.add(formattedHour)
                    }
                }
                if (dateHoursList.isNotEmpty()) {
                    dateHoursList.sort()

                    // Update the RecyclerView with the list of points
                    pontosMarcadosAdapter.pontosMarcados = dateHoursStringList
                    pontosMarcadosAdapter.notifyDataSetChanged()

                    // If the list has an odd number of elements, add the current time
                    if (dateHoursList.size % 2 != 0) {
                        dateHoursList.add(Date())
                    }

                    // Calculate and display total worked hours
                    var totalWorkedMillis: Long = 0
                    for (i in 0 until dateHoursList.size step 2) {
                        val startWork = dateHoursList[i]
                        val endWork = dateHoursList[i + 1]
                        totalWorkedMillis += endWork.time - startWork.time
                    }
                    val hours = TimeUnit.MILLISECONDS.toHours(totalWorkedMillis)
                    val minutes = TimeUnit.MILLISECONDS.toMinutes(totalWorkedMillis) % 60
                    horasTrabalhadasTextView.text = String.format("%02d:%02d", hours, minutes)
                } else {
                    pontosMarcadosAdapter.pontosMarcados = emptyList()
                    pontosMarcadosAdapter.notifyDataSetChanged()

                    horasTrabalhadasTextView.text = "00:00"
                }
            }
            .addOnFailureListener { exception ->
                Log.e("Firestore", "Error fetching data: ${exception.message}")
                pontosMarcadosAdapter.pontosMarcados = emptyList()
                pontosMarcadosAdapter.notifyDataSetChanged()

                horasTrabalhadasTextView.text = "00:00"
            }
    }

    private fun setupBotaoInicio(view: View) {
        val botaoInicio = view.findViewById<Button>(R.id.botao_inicio)
        botaoInicio.setOnClickListener {
            findNavController().navigate(R.id.action_relatorioFragment_to_inicioGeralFragment)
        }
    }
}
