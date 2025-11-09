import 'package:flutter/material.dart';
import 'package:flutter_application_salaoapp/_comum/minhas_cores.dart';
import 'package:flutter_application_salaoapp/_comum/snackbar.dart';
import 'package:flutter_application_salaoapp/componentes/decoration_campo_autenticacao.dart';
import 'package:flutter_application_salaoapp/servicos/autenticacao_servico.dart';
import 'package:flutter_application_salaoapp/pages/redefinir_page.dart';

class AutenticacaoTela extends StatefulWidget {
  const AutenticacaoTela({super.key});

  @override
  State<AutenticacaoTela> createState() => _AutenticacaoTelaState();
}

class _AutenticacaoTelaState extends State<AutenticacaoTela> {
  bool queroEntrar = true;
  final _formkey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();

  AutenticacaoServico _autenServico = AutenticacaoServico();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  MinhasCores.rosaTopoGradiente,
                  MinhasCores.rosaFundoGradiente,
                ],
              ),
            ),
          ),SingleChildScrollView( // <--- CORREÇÃO AQUI
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formkey,
                child: Column(
                  // Usamos MainAxisAlignment.center e CrossAxisAlignment.stretch
                  // para centralizar na horizontal e esticar os campos.
                  // MainAxisAlignment.center pode ser um problema se o conteúdo
                  // for muito pequeno, mas geralmente funciona bem.
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Para garantir que o topo da tela seja seguro (como sob a bateria/câmera)
                    // e para empurrar o conteúdo para baixo.
                    SizedBox(height: MediaQuery.of(context).padding.top + 32), 
                    
                    Image.asset("assets/logo.png", height: 150),
                    const Text(
                      "Prism Hair",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: getAuthenticationInputDecoration("E-mail"),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "E-mail é obrigatório";
                        }
                        if (value.length < 5) {
                          return "E-mail muito curto";
                        }
                        if (!value.contains("@")) {
                          return "E-mail inválido";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _senhaController,
                      decoration: getAuthenticationInputDecoration("Senha"),
                      obscureText: true,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Senha é obrigatória";
                        }
                        if (value.length < 5) {
                          return "Senha muito curta";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    Visibility(
                      visible: !queroEntrar,
                      child: Column(
                        children: [
                          TextFormField(
                            // É recomendado ter um Controller aqui para a confirmação de senha
                            decoration: getAuthenticationInputDecoration(
                              "Confirme a Senha",
                            ),
                            obscureText: true,
                            validator: (String? value) {
                              if (!queroEntrar && (value == null || value.isEmpty)) {
                                return "A confirmação de Senha não pode ser vazia";
                              }
                              // Adicione validação para comparar com a senha original
                              if (!queroEntrar && value != _senhaController.text) {
                                return "As senhas não coincidem";
                              }
                              if (value != null && value.length < 5) {
                                return "Senha muito curta";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _nomeController,
                            decoration: getAuthenticationInputDecoration("Nome"),
                            validator: (String? value) {
                              if (!queroEntrar && (value == null || value.isEmpty)) {
                                return "Nome é obrigatório";
                              }
                              if (value != null && value.length < 5) {
                                return "Nome muito curto";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        botaoPrincipalClicado();
                      },
                      child: Text((queroEntrar) ? "Entrar" : "Cadastrar"),
                    ),
                    ElevatedButton.icon(
                      icon: Image.network(
                        'https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/google.png',
                        height: 24,
                      ),
                      label: const Text(
                        'Entrar com Google',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 42),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: const BorderSide(color: Colors.grey),
                        ),
                      ),
                      onPressed: () async {
                        final userCredential = await AutenticacaoServico()
                            .loginComGoogle();
                        if (userCredential != null) {
                          Navigator.pushReplacementNamed(context, '/home');
                        }
                      },
                    ),

                    const Divider(),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          queroEntrar = !queroEntrar;
                        });
                      },
                      child: Text(
                        (queroEntrar)
                            ? "Ainda não tenho conta, cadastrar!"
                            : "Já tenho conta, entrar!",
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RedefinirSenhaPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Esqueceu a senha?',
                        style: TextStyle(color: Colors.pinkAccent),
                      ),
                    ),
                    // Garantir que haja um espaço extra na parte inferior, se necessário
                    const SizedBox(height: 32), 
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  botaoPrincipalClicado() {
    String nome = _nomeController.text;
    String email = _emailController.text;
    String senha = _senhaController.text;

    if (_formkey.currentState!.validate()) {
      if (queroEntrar) {
        print("Entrada Válida");
        _autenServico.logarUsuario(email: email, senha: senha).then((
          String? erro,
        ) {
          if (erro != null) {
            mostrarSnackBar(context: context, texto: erro);
          }
        });
      } else {
        print("Cadastro Válido");
        print(
          "${_emailController.text}, ${_senhaController.text}, ${_nomeController.text} ",
        );
        _autenServico
            .cadastrarUsuario(nome: nome, senha: senha, email: email)
            .then((String? erro) {
              if (erro != null) {
                mostrarSnackBar(context: context, texto: erro);
              }
            });
      }
    } else {
      print("Form Inválido");
    }
  }
}