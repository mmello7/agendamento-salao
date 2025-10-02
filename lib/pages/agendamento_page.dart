import 'package:flutter/material.dart';
import 'package:flutter_application_salaoapp/models/servico_model.dart';

class AgendamentoPage extends StatefulWidget {
  final ServicoModel servico;

  const AgendamentoPage({Key? key, required this.servico}) : super(key: key);

  @override
  State<AgendamentoPage> createState() => _AgendamentoPageState();
}

class _AgendamentoPageState extends State<AgendamentoPage> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agendar ${widget.servico.name}'),
        backgroundColor: Colors.pink[100],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Serviço: ${widget.servico.name}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Descrição: ${widget.servico.descricao}',
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
                onPressed: () {
                  if (_selectedDate != null && _selectedTime != null) {
                    // Lógica para confirmar o agendamento
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Agendamento de ${widget.servico.name} para ${(_selectedDate!).day}/${(_selectedDate!).month}/${(_selectedDate!).year} às ${(_selectedTime!).format(context)} confirmado!',
                        ),
                      ),
                    );
                    Navigator.pop(context); // Volta para a tela anterior
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Por favor, selecione a data e a hora.'),
                      ),
                    );
                  }
                },
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
