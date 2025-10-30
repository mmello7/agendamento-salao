import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_salaoapp/_comum/Minhas_cores.dart';
import 'package:flutter_application_salaoapp/models/servico_model.dart';
import 'package:flutter_application_salaoapp/pages/agendamento_page.dart';
import 'package:flutter_application_salaoapp/pages/agendamentos_clientes_page.dart';
import 'package:flutter_application_salaoapp/servicos/autenticacao_servico.dart'; // Importar a página de agendamentos do cliente

class ServicoTela extends StatefulWidget {
  final User user;
  const ServicoTela({Key? key, required this.user}) : super(key: key);

  @override
  State<ServicoTela> createState() => _ServicoTelaState();
}

class _ServicoTelaState extends State<ServicoTela> {
  final List<ServicoModel> _servicosSelecionados = [];
  final List<ServicoModel> servicos = [
    ServicoModel(
      id: '1',
      name: 'Corte de Cabelo Feminino',
      servico: 'Corte',
      descricao: 'Corte moderno e personalizado para realçar sua beleza.',
      avaliacao: '4.8',
      urlImage: 'assets/images/corte-fem.jpg',
      price: 50.0,
    ),
    ServicoModel(
      id: '2',
      name: 'Corte de Cabelo Masculino',
      servico: 'Corte',
      descricao: 'Estilo e precisão para o seu visual.',
      avaliacao: '4.7',
      urlImage: 'assets/images/corte-masc.jpg',
      price: 40.0,
    ),
    ServicoModel(
      id: '3',
      name: 'Coloração Completa',
      servico: 'Coloração',
      descricao: 'Transforme seu cabelo com cores vibrantes e duradouras.',
      avaliacao: '4.9',
      urlImage: 'assets/images/coloracao.jpg',
      price: 150.0,
    ),
    ServicoModel(
      id: '4',
      name: 'Manicure e Pedicure',
      servico: 'Unhas',
      descricao: 'Unhas impecáveis e bem cuidadas para todas as ocasiões.',
      avaliacao: '4.6',
      urlImage: 'assets/images/mao-pe.jpg',
      price: 60.0,
    ),
    ServicoModel(
      id: '5',
      name: 'Tratamento Capilar',
      servico: 'Tratamento',
      descricao: 'Hidratação profunda e restauração para cabelos saudáveis.',
      avaliacao: '4.9',
      urlImage: 'assets/images/tratamento.jpg',
      price: 100.0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nossos Serviços'),
        backgroundColor: MinhasCores.rosaClaro, // Cor suave para salão
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
              accountName: Text(
                (widget.user.displayName != null)
                    ? widget.user.displayName!
                    : "",
              ),
              accountEmail: Text(widget.user.email!),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text("Deslogar"),
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
          return InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AgendamentoPage(
                    servicosSelecionados: [
                      servico,
                    ], // passa apenas o serviço clicado
                  ),
                ),
              );
            },
            child: Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (servico.urlImage != null &&
                        servico.urlImage!.isNotEmpty)
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
                                    Icons.error,
                                    color: Colors.red,
                                    size: 40,
                                  ),
                                ),
                              ),
                        ),
                      ),

                    const SizedBox(height: 15),
                    Text(
                      servico.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.pinkAccent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      servico.descricao,
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber[400], size: 20),
                        const SizedBox(width: 5),
                        Text(
                          servico.avaliacao,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: _servicosSelecionados.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AgendamentoPage(
                      servicosSelecionados: _servicosSelecionados,
                    ), // Passa a lista de serviços
                  ),
                );
              },
              backgroundColor: Colors.pinkAccent,
              icon: const Icon(Icons.calendar_today, color: Colors.white),
              label: const Text(
                'Agendar Selecionados',
                style: TextStyle(color: Colors.white),
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
    );
  }
}
