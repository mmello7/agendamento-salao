import 'package:flutter/material.dart';
import 'package:flutter_application_salaoapp/_comum/Minhas_cores.dart';
import 'package:flutter_application_salaoapp/models/agendamento_model.dart';
import 'package:flutter_application_salaoapp/models/servico_model.dart'; // Importar ServicoModel
import 'package:flutter_application_salaoapp/servicos/agendamento_servico.dart';
import 'package:flutter_application_salaoapp/pages/agendamentos_clientes_page.dart';

class EditarAgendamentoPage extends StatefulWidget {
  final Agendamento agendamento;

  const EditarAgendamentoPage({Key? key, required this.agendamento}) : super(key: key);

  @override
  State<EditarAgendamentoPage> createState() => _EditarAgendamentoPageState();
}

class _EditarAgendamentoPageState extends State<EditarAgendamentoPage> {
  final AgendamentoServico _agendamentoServico = AgendamentoServico();
  final _formKey = GlobalKey<FormState>();

  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late String _status;
  late String _observacoes;
  late List<ServicoModel> _servicosSelecionados;

  // Lista de serviços disponíveis (simulada, idealmente viria de um serviço)
  final List<ServicoModel> _servicosDisponiveis = [
    ServicoModel(id: '1', name: 'Corte de Cabelo Feminino', servico: 'Corte', descricao: '', avaliacao: '4.8', urlImage: '', price: 50.0),
    ServicoModel(id: '2', name: 'Corte de Cabelo Masculino', servico: 'Corte', descricao: '', avaliacao: '4.7', urlImage: '', price: 40.0),
    ServicoModel(id: '3', name: 'Coloração Completa', servico: 'Coloração', descricao: '', avaliacao: '4.9', urlImage: '', price: 150.0),
    ServicoModel(id: '4', name: 'Manicure e Pedicure', servico: 'Unhas', descricao: '', avaliacao: '4.6', urlImage: '', price: 60.0),
    ServicoModel(id: '5', name: 'Tratamento Capilar', servico: 'Tratamento', descricao: '', avaliacao: '4.9', urlImage: '', price: 100.0),
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.agendamento.dataHora;
    _selectedTime = TimeOfDay.fromDateTime(widget.agendamento.dataHora);
    _status = widget.agendamento.status;
    _observacoes = widget.agendamento.observacoes ?? '';
    _servicosSelecionados = widget.agendamento.servicos.map((s) {
      return _servicosDisponiveis.firstWhere((element) => element.id == s['id'],
          orElse: () => ServicoModel(id: s['id'], name: s['nome'], servico: '', descricao: '', avaliacao: '', urlImage: '', price: s['preco']));
    }).toList();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
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
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _salvarAlteracoes() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final DateTime novaDataHora = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      final List<Map<String, dynamic>> servicosData = _servicosSelecionados.map((s) => {
        'id': s.id,
        'nome': s.name,
        'preco': s.price,
      }).toList();

      final Agendamento agendamentoAtualizado = Agendamento(
        id: widget.agendamento.id, // Manter o mesmo ID
        userId: widget.agendamento.userId,
        userName: widget.agendamento.userName,
        dataHora: novaDataHora,
        servicos: servicosData,
        status: _status,
        observacoes: _observacoes.isEmpty ? null : _observacoes,
        criadoEm: widget.agendamento.criadoEm,
      );

      String? erro = await _agendamentoServico.editarAgendamento(agendamentoAtualizado);

      if (erro == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Agendamento atualizado com sucesso!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AgendamentosClientePage(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar agendamento: $erro')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Agendamento'),
        backgroundColor: MinhasCores.rosaClaro,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ListTile(
                title: Text(
                  'Data Selecionada: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              ListTile(
                title: Text(
                  'Hora Selecionada: ${_selectedTime.format(context)}',
                ),
                trailing: const Icon(Icons.access_time),
                onTap: () => _selectTime(context),
              ),
              const SizedBox(height: 20),
              Text('Serviços Selecionados:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ..._servicosDisponiveis.map((servico) {
                return CheckboxListTile(
                  title: Text(servico.name),
                  value: _servicosSelecionados.any((s) => s.id == servico.id),
                  onChanged: (bool? selected) {
                    setState(() {
                      if (selected != null && selected) {
                        _servicosSelecionados.add(servico);
                      } else {
                        _servicosSelecionados.removeWhere((s) => s.id == servico.id);
                      }
                    });
                  },
                );
              }).toList(),
              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(labelText: 'Status'),
                items: <String>['pendente', 'confirmado', 'concluído', 'cancelado']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _status = newValue!;
                  });
                },
                onSaved: (value) => _status = value ?? 'pendente',
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: _observacoes,
                decoration: const InputDecoration(labelText: 'Observações (Opcional)'),
                maxLines: 3,
                onSaved: (value) => _observacoes = value ?? '',
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _salvarAlteracoes,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Salvar Alterações',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

