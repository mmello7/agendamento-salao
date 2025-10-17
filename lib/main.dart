import 'package:flutter/material.dart';
import 'package:flutter_application_salaoapp/pages/autenticacao_page.dart';
<<<<<<< HEAD
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
 
=======
import 'package:flutter_application_salaoapp/pages/servico_page.dart';

void main() {
  runApp(const MyApp());
>>>>>>> 54117a2efa8f8929603d7cbd1cd98d92464f7ba5
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
