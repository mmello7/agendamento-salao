import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_salaoapp/_comum/Minhas_cores.dart';
import 'package:flutter_application_salaoapp/models/servico_model.dart';
import 'package:flutter_application_salaoapp/pages/agendamento_page.dart';
import 'package:flutter_application_salaoapp/pages/agendamentos_clientes_page.dart';
import 'package:flutter_application_salaoapp/servicos/autenticacao_servico.dart';

class ServicoTela extends StatefulWidget {
  final User user;
  const ServicoTela({Key? key, required this.user}) : super(key: key);

  @override
  State<ServicoTela> createState() => _ServicoTelaState();
}

class _ServicoTelaState extends State<ServicoTela> {
  // Lista para rastrear os IDs dos serviços selecionados
  final List<String> _servicosSelecionadosIds = []; 
  
  final List<ServicoModel> servicos = [
    ServicoModel(
      id: '1',
      name: 'Corte de Cabelo Feminino',
      servico: 'Corte',
      descricao: 'Corte moderno e personalizado para realçar sua beleza.',
      avaliacao: '4.8',
      urlImage: 'corte-fem.jpg',
      price: 50.0,
    ),
    ServicoModel(
      id: '2',
      name: 'Corte de Cabelo Masculino',
      servico: 'Corte',
      descricao: 'Estilo e precisão para o seu visual.',
      avaliacao: '4.7',
      urlImage: 'corte-masc.jpg',
      price: 40.0,
    ),
    ServicoModel(
      id: '3',
      name: 'Coloração Completa',
      servico: 'Coloração',
      descricao: 'Transforme seu cabelo com cores vibrantes e duradouras.',
      avaliacao: '4.9',
      urlImage: 'coloracao.jpg',
      price: 150.0,
    ),
    ServicoModel(
      id: '4',
      name: 'Manicure e Pedicure',
      servico: 'Unhas',
      descricao: 'Unhas impecáveis e bem cuidadas para todas as ocasiões.',
      avaliacao: '4.6',
      urlImage: 'mao-pe.jpg',
      price: 60.0,
    ),
    ServicoModel(
      id: '5',
      name: 'Tratamento Capilar',
      servico: 'Tratamento',
      descricao: 'Hidratação profunda e restauração para cabelos saudáveis.',
      avaliacao: '4.9',
      urlImage: 'tratamento.jpg',
      price: 100.0,
    ),
  ];
  
  // Novo método para adicionar/remover o serviço
  void _toggleServicoSelection(ServicoModel servico) {
    setState(() {
      if (_servicosSelecionadosIds.contains(servico.id)) {
        _servicosSelecionadosIds.remove(servico.id);
      } else {
        _servicosSelecionadosIds.add(servico.id!);
      }
    });
  }

  // Novo método para calcular o preço total
  double _calcularTotal() {
    return servicos
        .where((s) => _servicosSelecionadosIds.contains(s.id))
        .fold(0.0, (total, current) => total + (current.price ?? 0.0));
  }

  // Novo método para obter a lista completa de objetos ServicoModel selecionados
  List<ServicoModel> _getServicosSelecionados() {
    return servicos
        .where((s) => _servicosSelecionadosIds.contains(s.id))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final totalSelecionado = _calcularTotal();
    final quantidadeSelecionada = _servicosSelecionadosIds.length;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nossos Serviços'),
        backgroundColor: MinhasCores.rosaClaro,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: const CircleAvatar(),
              accountName: Text(
                (widget.user.displayName != null)
                    ? widget.user.displayName!
                    : "Cliente",
              ),
              accountEmail: Text(widget.user.email!),
            ),
            ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text("Meus Agendamentos"),
              onTap: () {
                Navigator.of(context).pop(); // Fecha o Drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AgendamentosClientePage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Deslogar"),
              onTap: () {
                AutenticacaoServico().deslogar();
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: servicos.length,
        itemBuilder: (context, index) {
          final servico = servicos[index];
          final isSelected = _servicosSelecionadosIds.contains(servico.id);
          
          return InkWell(
            borderRadius: BorderRadius.circular(15),
            // Ao invés de navegar, agora ele apenas seleciona/desseleciona
            onTap: () => _toggleServicoSelection(servico),
            child: Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              // Destaca o card se estiver selecionado
              color: isSelected ? MinhasCores.rosaClaro.withOpacity(0.3) : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Área da Imagem
                    if (servico.urlImage != null && servico.urlImage!.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.asset(
                          'assets/images/${servico.urlImage}',
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                height: 180,
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    color: Colors.red,
                                    size: 40,
                                  ),
                                ),
                              ),
                        ),
                      ),
                    const SizedBox(height: 15),
                    
                    // Nome e Preço
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            servico.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.pinkAccent,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        
                        // Icone de Seleção
                        Icon(
                          isSelected ? Icons.check_circle : Icons.circle_outlined,
                          color: isSelected ? Colors.green : Colors.grey,
                          size: 30,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Descrição
                    Text(
                      servico.descricao,
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),

                    // Preço e Avaliação
                    Row(
                      children: [
                        Text(
                          'R\$ ${(servico.price ?? 0.0).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.black87,
                          ),
                        ),
                        const Spacer(),
                        Icon(Icons.star, color: Colors.amber[400], size: 20),
                        const SizedBox(width: 5),
                        Text(
                          servico.avaliacao,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      
      // Floating Action Button agora é um carrinho que aparece ao selecionar algo
      floatingActionButton: quantidadeSelecionada > 0
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AgendamentoPage(
                      servicosSelecionados: _getServicosSelecionados(), // Passa a lista completa
                    ), 
                  ),
                );
              },
              backgroundColor: Colors.pinkAccent,
              icon: const Icon(Icons.calendar_today, color: Colors.white),
              label: Text(
                'Agendar $quantidadeSelecionada Serviços (R\$ ${totalSelecionado.toStringAsFixed(2)})',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )
          : FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AgendamentosClientePage(),
                  ),
                );
              },
              backgroundColor: Colors.pinkAccent,
              child: const Icon(Icons.list, color: Colors.white),
              tooltip: 'Ver Meus Agendamentos',
            ),
      // Adiciona um botão de Agendar (extended) ou de Ver Meus Agendamentos (simples)
      floatingActionButtonLocation: quantidadeSelecionada > 0 
          ? FloatingActionButtonLocation.centerFloat 
          : FloatingActionButtonLocation.endFloat,
    );
  }
}