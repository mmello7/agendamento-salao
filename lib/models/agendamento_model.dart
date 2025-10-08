import 'package:flutter_application_salaoapp/models/servico_model.dart';

class AgendamentoModel {
  final String id;
  final ServicoModel servico;
  final DateTime data;
  final String hora;

  AgendamentoModel({
    required this.id,
    required this.servico,
    required this.data,
    required this.hora,
  });
}
