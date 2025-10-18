import 'package:flutter/material.dart';
import 'package:flutter_application_salaoapp/models/servico_model.dart';
import 'package:flutter_application_salaoapp/servicos/agendamento_servico.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importar FirebaseAuth para obter o usuário atual
import 'package:flutter_application_salaoapp/models/agendamento_model.dart'; // Importar o modelo de agendamento
import 'package:flutter_application_salaoapp/pages/agendamentos_clientes_page.dart'; // Importar a página de agendamentos do cliente


class AgendamentoPage extends StatefulWidget {
  final List<ServicoModel> servicosSelecionados; // Alterado para lista de serviços

  const AgendamentoPage({Key? key, required this.servicosSelecionados}): super(key: key);

  @override
  State<AgendamentoPage> createState() => _AgendamentoPageState();
}

class _AgendamentoPageState extends State<AgendamentoPage> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  late final AgendamentoServico _agendamentoServico;
  late final FirebaseAuth _auth;

  @override
  void initState() {
    super.initState();
    _agendamentoServico = AgendamentoServico();
    _auth = FirebaseAuth.instance;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2026),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _confirmarAgendamento() async { // Alterado para async
    if (_selectedDate != null && _selectedTime != null) {
      final User? user = _auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro: Usuário não autenticado.'),
          ),
        );
        return;
      }

      final DateTime agendamentoDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      final List<Map<String, dynamic>> servicosData = widget.servicosSelecionados.map((s) => {
        'id': s.id,
        'nome': s.name,
        'preco': s.price,
      }).toList();

      final Agendamento newAgendamento = Agendamento(
        userId: user.uid,
        userName: user.displayName ?? "Usuário", // Usa o nome do usuário ou "Usuário"
        dataHora: agendamentoDateTime,
        servicos: servicosData,
        profissional: "A definir", // Pode ser selecionado em outra tela ou definido por padrão
        status: "pendente",
        criadoEm: DateTime.now(),
      );

      String? erro = await _agendamentoServico.criarAgendamento(newAgendamento);

      if (erro == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Agendamento de ${widget.servicosSelecionados.map((s) => s.name).join(', ')} para ${(_selectedDate!).day}/${(_selectedDate!).month}/${(_selectedDate!).year} às ${(_selectedTime!).format(context)} confirmado!',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao agendar: $erro'),
          ),
        );
      }
      // Navega para a tela de agendamentos do cliente
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AgendamentosClientePage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecione a data e a hora.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agendar Serviços'), // Título genérico para múltiplos serviços
        backgroundColor: Colors.pink[100],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Serviços Selecionados: ${widget.servicosSelecionados.map((s) => s.name).join(', ')}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Total de Serviços: ${widget.servicosSelecionados.length}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ListTile(
              title: Text(
                _selectedDate == null
                    ? 'Selecionar Data'
                    : 'Data Selecionada: ${(_selectedDate!).day}/${(_selectedDate!).month}/${(_selectedDate!).year}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),
            ListTile(
              title: Text(
                _selectedTime == null
                    ? 'Selecionar Hora'
                    : 'Hora Selecionada: ${(_selectedTime!).format(context)}',
              ),
              trailing: const Icon(Icons.access_time),
              onTap: () => _selectTime(context),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _confirmarAgendamento,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Confirmar Agendamento',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
