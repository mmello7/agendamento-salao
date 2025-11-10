import 'package:flutter/material.dart';
import 'package:flutter_application_salaoapp/models/servico_model.dart';
import 'package:flutter_application_salaoapp/servicos/agendamento_servico.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importar FirebaseAuth para obter o usuário atual
import 'package:flutter_application_salaoapp/models/agendamento_model.dart'; // Importar o modelo de agendamento
import 'package:flutter_application_salaoapp/pages/agendamentos_clientes_page.dart'; // Importar a página de agendamentos do cliente

class AgendamentoPage extends StatefulWidget {
  final List<ServicoModel>
  servicosSelecionados; // Alterado para lista de serviços

  const AgendamentoPage({Key? key, required this.servicosSelecionados})
    : super(key: key);

  @override
  State<AgendamentoPage> createState() => _AgendamentoPageState();
}

class _AgendamentoPageState extends State<AgendamentoPage> {
  DateTime? _selectedDate;
  String? _selectedHour;

  final List<String> _horariosDisponiveis = [
    "09:00",
    "10:00",
    "11:00",
    "13:00",
    "14:00",
    "15:00",
    "16:00",
    "17:00",
    "18:00",
  ];

  List<String> _horariosOcupados = [];
  bool _isLoadingHorarios = false;

  late final AgendamentoServico _agendamentoServico;
  late final FirebaseAuth _auth;

  @override
  void initState() {
    super.initState();
    _agendamentoServico = AgendamentoServico();
    _auth = FirebaseAuth.instance;
  }

  Future<void> _fetchHorariosOcupados(DateTime data) async {
    setState(() {
      _isLoadingHorarios = true;
      _horariosOcupados = [];
      _selectedHour = null;
    });

    try {
      final ocupados = await _agendamentoServico.getHorariosOcupados(data);
      setState(() {
        _horariosOcupados = ocupados;
      });
    } catch (e) {
      print("Erro ao buscar horários ocupados: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao buscar horários disponíveis.')),
      );
    } finally {
      setState(() {
        _isLoadingHorarios = false;
      });
    }
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
        _selectedHour = null;
      });
      await _fetchHorariosOcupados(picked);
    }
  }

  void _confirmarAgendamento() async {
    // Alterado para async
    if (_selectedDate != null && _selectedHour != null) {
      final User? user = _auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro: Usuário não autenticado.')),
        );
        return;
      }

      final List<String> partes = _selectedHour!.split(':');
      final int hour = int.parse(partes[0]);
      final int minute = int.parse(partes[1]);

      final DateTime agendamentoDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        hour,
        minute,
      );

      final List<Map<String, dynamic>> servicosData = widget
          .servicosSelecionados
          .map((s) => {'id': s.id, 'nome': s.name, 'preco': s.price})
          .toList();

      final Agendamento newAgendamento = Agendamento(
        userId: user.uid,
        userName:
            user.displayName ?? "Usuário", // Usa o nome do usuário ou "Usuário"
        dataHora: agendamentoDateTime,
        servicos: servicosData,
        status: "Agendado",
        criadoEm: DateTime.now(),
      );

      String? erro = await _agendamentoServico.criarAgendamento(newAgendamento);

      if (erro == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Agendamento de ${widget.servicosSelecionados.map((s) => s.name).join(', ')} para ${(_selectedDate!).day}/${(_selectedDate!).month}/${(_selectedDate!).year} às $_selectedHour confirmado!',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao agendar: $erro')));
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
        const SnackBar(content: Text('Por favor, selecione a data e a hora.')),
      );
    }
  }

  Widget _buildHorarioItem(String horario) {
    // 1. Verifica se o horário está ocupado
    final isOcupado = _horariosOcupados.contains(horario);
    // 2. Verifica se o horário está selecionado pelo usuário
    final isSelecionado = _selectedHour == horario;

    // Define a cor de fundo
    Color corFundo = isOcupado
        ? Colors.grey[400]! // Cor mais escura para OCUPADO
        : isSelecionado
            ? Colors.pink[400]! // Cor para SELECIONADO
            : Colors.grey[200]!; // Cor padrão

    // Define a cor do texto
    Color corTexto = isSelecionado ? Colors.white : Colors.black;
    if (isOcupado) {
      corTexto = Colors.grey[600]!; // Texto escurecido para indisponível
    }

    return GestureDetector(
      // Se estiver ocupado, onTap é nulo (não clicável)
      onTap: isOcupado
          ? null
          : () {
              setState(() {
                _selectedHour = horario;
              });
            },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: corFundo,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isOcupado ? Colors.grey[400]! : Colors.pink[200]!,
            width: 1,
          ),
        ),
        child: Text(
          horario,
          style: TextStyle(
            color: corTexto,
            fontWeight: FontWeight.bold,
            decoration: isOcupado ? TextDecoration.lineThrough : null, // Riscado se ocupado
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Agendar Serviços',
        ), // Título genérico para múltiplos serviços
        backgroundColor: Colors.pink[100],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Informações dos Serviços
            Text(
              'Serviços Selecionados: ${widget.servicosSelecionados.map((s) => s.name).join(', ')}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // ... (restante das informações de serviço) ...
            
            const SizedBox(height: 20),

            // SELEÇÃO DE DATA
            ListTile(
              title: Text(
                _selectedDate == null
                    ? '1. Selecionar Data'
                    : '1. Data Selecionada: ${(_selectedDate!).day}/${(_selectedDate!).month}/${(_selectedDate!).year}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: const Icon(Icons.calendar_today, color: Colors.pink),
              onTap: () => _selectDate(context),
            ),
            
            const SizedBox(height: 20),
            
            // SELEÇÃO DE HORA (GRADE DE BOTÕES)
            if (_selectedDate != null) ...[
              const Text(
                '2. Selecionar Horário:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Indicador de Carregamento
              if (_isLoadingHorarios)
                const Center(child: CircularProgressIndicator(color: Colors.pink)),
              
              // Grade de Horários
              if (!_isLoadingHorarios)
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 3 botões por linha
                    childAspectRatio: 2.5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: _horariosDisponiveis.length,
                  itemBuilder: (context, index) {
                    final horario = _horariosDisponiveis[index];
                    return _buildHorarioItem(horario);
                  },
                ),
              
              const SizedBox(height: 30),
              
              // BOTÃO DE CONFIRMAR
              Center(
                child: ElevatedButton(
                  onPressed: _selectedDate != null && _selectedHour != null 
                      ? _confirmarAgendamento 
                      : null, // Desabilitado se data ou hora não for selecionada
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
          ],
        ),
      ),
    );
  }
}