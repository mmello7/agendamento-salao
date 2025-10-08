import 'package:flutter/material.dart';
import 'package:flutter_application_salaoapp/models/servico_model.dart';
import 'package:flutter_application_salaoapp/pages/agendamento_page.dart';
import 'package:flutter_application_salaoapp/pages/agendamentos_clientes_page.dart'; // Importar a página de agendamentos do cliente

class ServicoTela extends StatefulWidget {
  const ServicoTela({Key? key}) : super(key: key);

  @override
  State<ServicoTela> createState() => _ServicoTelaState();
}

class _ServicoTelaState extends State<ServicoTela> {
  final List<ServicoModel> servicos = [
    ServicoModel(
      id: '1',
      name: 'Corte de Cabelo Feminino',
      servico: 'Corte',
      descricao: 'Corte moderno e personalizado para realçar sua beleza.',
      avaliacao: '4.8',
      urlImage: 'https://images.unsplash.com/photo-1595476108010-b49e8275ccf8?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
     ),
    ServicoModel(
      id: '2',
      name: 'Corte de Cabelo Masculino',
      servico: 'Corte',
      descricao: 'Estilo e precisão para o seu visual.',
      avaliacao: '4.7',
      urlImage: 'https://images.unsplash.com/photo-1621607509154-bf6285e7593e?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
     ),
    ServicoModel(
      id: '3',
      name: 'Coloração Completa',
      servico: 'Coloração',
      descricao: 'Transforme seu cabelo com cores vibrantes e duradouras.',
      avaliacao: '4.9',
      urlImage: 'https://images.unsplash.com/photo-1521602736140-192534641977?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
     ),
    ServicoModel(
      id: '4',
      name: 'Manicure e Pedicure',
      servico: 'Unhas',
      descricao: 'Unhas impecáveis e bem cuidadas para todas as ocasiões.',
      avaliacao: '4.6',
      urlImage: 'https://images.unsplash.com/photo-1583947041727-eb424885066c?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
     ),
    ServicoModel(
      id: '5',
      name: 'Tratamento Capilar',
      servico: 'Tratamento',
      descricao: 'Hidratação profunda e restauração para cabelos saudáveis.',
      avaliacao: '4.9',
      urlImage: 'https://images.unsplash.com/photo-1521590832167-9ee28dcdad93?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
     ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nossos Serviços'),
        backgroundColor: const Color.fromARGB(255, 233, 116, 157), // Cor suave para salão
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(32),
            ),
          ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: servicos.length,
        itemBuilder: (context, index) {
          final servico = servicos[index];
          return Card(
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
                  if (servico.urlImage != null && servico.urlImage!.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        servico.urlImage!,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 180,
                          color: const Color.fromARGB(255, 224, 224, 224),
                          child: const Center(child: Icon(Icons.broken_image, size: 50, color: Colors.grey)),
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
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
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
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AgendamentoPage(servico: servico),
                            ),
                          );
                        },
                        icon: const Icon(Icons.calendar_today),
                        label: const Text('Agendar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent, // Cor do botão
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
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
