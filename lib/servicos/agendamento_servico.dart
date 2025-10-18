import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/agendamento_model.dart';

class AgendamentoServico {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  // Método para listar agendamentos do usuário atual
  Stream<List<Agendamento>> listarAgendamentos() {
    if (currentUser == null) {
      return Stream.value([]); // Retorna um stream vazio se o usuário não estiver autenticado
    }
    return _firestore
        .collection("agendamentos")
        .where("userId", isEqualTo: currentUser!.uid) // Filtra por agendamentos do usuário atual
        .orderBy("dataHora", descending: true) // Ordena por data e hora
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Agendamento.fromFirestore(doc, null))
            .toList());
  }

  // Método para criar um novo agendamento
  Future<String?> criarAgendamento(Agendamento agendamento) async {
    if (currentUser == null) {
      return "Usuário não autenticado.";
    }

    try {
      await _firestore.collection('agendamentos').add(agendamento.toMap());
      return null; // Retorna null em caso de sucesso
    } on FirebaseException catch (e) {
      return e.message; // Retorna a mensagem de erro em caso de falha
    }
  }

  // Método para cancelar um agendamento
  Future<String?> cancelarAgendamento(String agendamentoId) async {
    if (currentUser == null) {
      return "Usuário não autenticado.";
    }

    try {
      await _firestore.collection("agendamentos").doc(agendamentoId).update({
        "status": "cancelado",
      });
      return null;
    } on FirebaseException catch (e) {
      return e.message;
    }
  }

  // Método para editar um agendamento existente
  Future<String?> editarAgendamento(Agendamento agendamento) async {
    if (currentUser == null) {
      return "Usuário não autenticado.";
    }
    if (agendamento.id == null) {
      return "ID do agendamento não fornecido para edição.";
    }

    try {
      await _firestore.collection("agendamentos").doc(agendamento.id).update(agendamento.toMap());
      return null;
    } on FirebaseException catch (e) {
      return e.message;
    }
  }
}

