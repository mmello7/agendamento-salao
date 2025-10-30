import 'package:flutter/material.dart';
import 'package:flutter_application_salaoapp/models/agendamento_model.dart';
import 'package:flutter_application_salaoapp/servicos/agendamento_servico.dart';
import 'package:flutter_application_salaoapp/pages/editar_agendamento_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AgendamentosClientePage extends StatefulWidget {
  const AgendamentosClientePage({Key? key}) : super(key: key);

  @override
  State<AgendamentosClientePage> createState() => _AgendamentosClientePageState();
}

class _AgendamentosClientePageState extends State<AgendamentosClientePage> {
  final AgendamentoServico _agendamentoServico = AgendamentoServico();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _cancelarAgendamento(String agendamentoId) async {
    final String? erro = await _agendamentoServico.cancelarAgendamento(agendamentoId);
    if (erro == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Agendamento cancelado com sucesso!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao cancelar agendamento: $erro")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus Agendamentos"),
        backgroundColor: Colors.pink[100],
        centerTitle: true,
      ),
      body: StreamBuilder<List<Agendamento>>(
        stream: _agendamentoServico.listarAgendamentos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar agendamentos: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Nenhum agendamento encontrado.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final agendamentos = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: agendamentos.length,
            itemBuilder: (context, index) {
              final agendamento = agendamentos[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  title: Text(
                    agendamento.servicos.map((s) => s['nome']).join(', '),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.pinkAccent,
                    ),
                  ),
                  subtitle: Text(
                    "Data: ${agendamento.dataHora.day}/${agendamento.dataHora.month}/${agendamento.dataHora.year} - "
                    "Hora: ${agendamento.dataHora.hour}:${agendamento.dataHora.minute.toString().padLeft(2, '0')}\n"
                    "Status: ${agendamento.status}",
                    style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditarAgendamentoPage(
                                agendamento: agendamento,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _cancelarAgendamento(agendamento.id!),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
