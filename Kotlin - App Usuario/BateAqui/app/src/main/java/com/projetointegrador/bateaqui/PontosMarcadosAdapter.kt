package com.projetointegrador.bateaqui

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView

class PontosMarcadosAdapter(var pontosMarcados: List<String>) :
    RecyclerView.Adapter<PontosMarcadosAdapter.ViewHolder>() {

    class ViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        val textViewPontoMarcado: TextView = itemView.findViewById(R.id.textViewPontoMarcado)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.item_ponto_marcado, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val pontoMarcado = pontosMarcados[position]
        holder.textViewPontoMarcado.text = pontoMarcado
    }

    override fun getItemCount(): Int {
        return pontosMarcados.size
    }
}
