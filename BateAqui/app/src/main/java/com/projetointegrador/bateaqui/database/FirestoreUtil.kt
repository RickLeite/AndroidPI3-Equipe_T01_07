package com.projetointegrador.bateaqui.database
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase

object FirestoreUtil {
    private val db: FirebaseFirestore by lazy { Firebase.firestore }

    fun addPonto(userPonto: UserPonto, onSuccess: (String) -> Unit, onFailure: (Exception) -> Unit) {
        db.collection("user_pontos")
            .add(userPonto)
            .addOnSuccessListener { documentReference ->
                onSuccess(documentReference.id)
            }
            .addOnFailureListener { e ->
                onFailure(e)
            }
    }
}
