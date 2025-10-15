import 'package:flutter/material.dart';
import 'package:flutter_application_salaoapp/pages/autenticacao_page.dart';
import 'package:flutter_application_salaoapp/pages/servico_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Salão App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AutenticacaoTela(), // Define ServicoTela como a página inicial
    );
  }
}
