import 'package:cloud_firestore/cloud_firestore.dart';

class Agendamento {
  final String? id;
  final String userId;
  final String userName;
  final DateTime dataHora;
  final List<Map<String, dynamic>> servicos;
  final String status;
  final String? observacoes;
  final DateTime criadoEm;

  Agendamento({
    this.id,
    required this.userId,
    required this.userName,
    required this.dataHora,
    required this.servicos,
    required this.status,
    this.observacoes,
    required this.criadoEm,
  });

  // Converte um objeto Agendamento para um Map para ser salvo no Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'dataHora': Timestamp.fromDate(dataHora),
      'servicos': servicos,
      'status': status,
      'observacoes': observacoes,
      'criadoEm': Timestamp.fromDate(criadoEm),
    };
  }

  // Construtor factory para criar um objeto Agendamento a partir de um DocumentSnapshot do Firestore
  factory Agendamento.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data();
    if (data == null) {
      throw StateError('missing data for agendamentoId: ${snapshot.id}');
    }

    return Agendamento(
      id: snapshot.id,
      userId: data['userId'] as String,
      userName: data['userName'] as String,
      dataHora: (data['dataHora'] as Timestamp).toDate(),
      servicos: List<Map<String, dynamic>>.from(data['servicos'] as List),
      status: data['status'] as String,
      observacoes: data['observacoes'] as String?,
      criadoEm: (data['criadoEm'] as Timestamp).toDate(),
    );
  }

  // Construtor factory para criar um objeto Agendamento a partir de um Map (útil para testes ou dados locais)
  factory Agendamento.fromMap(Map<String, dynamic> map) {
    return Agendamento(
      id: map['id'] as String?,
      userId: map['userId'] as String,
      userName: map['userName'] as String,
      dataHora: (map['dataHora'] is Timestamp) ? (map['dataHora'] as Timestamp).toDate() : DateTime.parse(map['dataHora'] as String),
      servicos: List<Map<String, dynamic>>.from(map['servicos'] as List),
      status: map['status'] as String,
      observacoes: map['observacoes'] as String?,
      criadoEm: (map['criadoEm'] is Timestamp) ? (map['criadoEm'] as Timestamp).toDate() : DateTime.parse(map['criadoEm'] as String),
    );
  }
}

