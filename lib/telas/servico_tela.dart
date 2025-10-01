import 'package:flutter/material.dart';

class ServicoTela extends StatelessWidget {
  const ServicoTela({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Alisar o Cabelo")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {}, 
        child: const Icon(Icons.add),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () {}, 
                child: const Text("Enviar foto"),
            ),
            const Text(
              "Descrição do serviço", 
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 18,
            ),
            ),
            const Text(
              "O botox é um tratamento estético"),
            const Divider(),
            const Text(
              "Resultado", 
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 18,
            ),
            ),
          ],
                ),
        ),
    );
  }
}