import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/agendamento_model.dart'; // Ajuste o caminho conforme necessário

class AgendamentoServico {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  // Método para listar agendamentos do usuário atual.
  // O filtro de status é aplicado no lado do Flutter (cliente) para funcionar
  // com o índice simples do Firebase e garantir a atualização em tempo real.
  Stream<List<Agendamento>> listarAgendamentos() {
    if (currentUser == null) {
      return Stream.value([]);
    }
    
    // Query do Firestore: Busca apenas pelo userId e ordena pela data.
    return _firestore
        .collection("agendamentos")
        .where("userId", isEqualTo: currentUser!.uid)
        .orderBy("dataHora", descending: true)
        .snapshots()
        .map((snapshot) {
          
          // 1. Mapeia todos os documentos do Firestore para objetos Agendamento
          List<Agendamento> todosAgendamentos = snapshot.docs
              .map((doc) => Agendamento.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>, null))
              .toList();

          // 2. FILTRO NO DART: Retorna apenas os agendamentos que NÃO estão 'cancelado'.
          // É isso que faz o item sumir da tela instantaneamente após o cancelamento.
          return todosAgendamentos.where((agendamento) => agendamento.status != 'cancelado').toList();
        });
  }

  // Método para criar um novo agendamento
  Future<String?> criarAgendamento(Agendamento agendamento) async {
    if (currentUser == null) {
      return "Usuário não autenticado.";
    }

    try {
      // Adiciona o campo 'status' como 'agendado' por padrão antes de salvar
      Map<String, dynamic> data = agendamento.toMap();
      data['status'] = 'agendado';
      
      await _firestore.collection('agendamentos').add(data);
      return null; // Retorna null em caso de sucesso
    } on FirebaseException catch (e) {
      print('Erro ao criar agendamento: ${e.code} -> ${e.message}');
      return e.message; // Retorna a mensagem de erro em caso de falha
    } catch (e) {
      print('Erro desconhecido ao criar agendamento: $e');
      return "Erro desconhecido ao criar agendamento.";
    }
  }

  // Método para cancelar um agendamento
  Future<String?> cancelarAgendamento(String agendamentoId) async {
    if (currentUser == null) {
      return "Usuário não autenticado.";
    }

    try {
      // Atualiza o campo 'status' para "cancelado"
      await _firestore
      .collection("agendamentos")
      .doc(agendamentoId)
      .update({"status": "cancelado"});
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