import 'package:flutter/material.dart';
import 'package:flutter_application_salaoapp/models/agendamento_model.dart';

// Lista global (simulada) para armazenar os agendamentos
// Em um aplicativo real, isso viria de um banco de dados ou API
List<AgendamentoModel> agendamentosGlobais = [];

class AgendamentosClientePage extends StatefulWidget {
  const AgendamentosClientePage({Key? key}) : super(key: key);

  @override
  State<AgendamentosClientePage> createState() => _AgendamentosClientePageState();
}

class _AgendamentosClientePageState extends State<AgendamentosClientePage> {
  // Usaremos uma cópia local da lista global para que as alterações de estado sejam refletidas
  List<AgendamentoModel> _agendamentos = [];

  @override
  void initState() {
    super.initState();
    _agendamentos = List.from(agendamentosGlobais); // Inicializa com os agendamentos globais
  }

  void _excluirAgendamento(String id) {
    setState(() {
      _agendamentos.removeWhere((agendamento) => agendamento.id == id);
      agendamentosGlobais.removeWhere((agendamento) => agendamento.id == id); // Remove também da lista global
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Agendamento excluído com sucesso!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus Agendamentos"),
        backgroundColor: Colors.pink[100],
        centerTitle: true,
      ),
      body: _agendamentos.isEmpty
          ? const Center(
              child: Text(
                "Nenhum agendamento encontrado.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _agendamentos.length,
              itemBuilder: (context, index) {
                final agendamento = _agendamentos[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    title: Text(
                      agendamento.servico.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.pinkAccent,
                      ),
                    ),
                    subtitle: Text(
                      "Data: ${agendamento.data.day}/${agendamento.data.month}/${agendamento.data.year} - Hora: ${agendamento.hora}",
                      style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _excluirAgendamento(agendamento.id),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
