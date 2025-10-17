import 'package:flutter/material.dart';
import 'package:flutter_application_salaoapp/_comum/minhas_cores.dart';
import 'package:flutter_application_salaoapp/_comum/snackbar.dart';
import 'package:flutter_application_salaoapp/componentes/decoration_campo_autenticacao.dart';
import 'package:flutter_application_salaoapp/servicos/autenticacao_servico.dart';

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
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset("assets/logo.png", height: 150),
                  const Text(
                    "Salon App",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: getAuthenticationInputDecoration("E-mail"),
                    validator: (String? value) {
                      if (value == null) {
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
                      if (value == null) {
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
                          decoration: getAuthenticationInputDecoration(
                            "Confirme a Senha",
                          ),
                          obscureText: true,
                          validator: (String? value) {
                            if (value == null) {
                              return "A confirmação de Senha não pode ser vazia";
                            }
                            if (value.length < 5) {
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
                            if (value == null) {
                              return "Nome é obrigatório";
                            }
                            if (value.length < 5) {
                              return "Nome muito curto";
                            }
                            return null;
                          },
                        ),
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
                  // Outros widgets da tela de autenticação viriam aqui
                ],
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
        _autenServico.logarUsuario(email: email, senha: senha).then(
          (String? erro) {
          if (erro != null) {
            mostrarSnackBar(context: context, texto: erro);
            }
          },
        );
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
              } else {
                mostrarSnackBar(
                  context: context,
                  texto: "Cadastro efetuado com Sucesso",
                  isErro: false,
                );
              }
            });
      }
    } else {
      print("Form Inválido");
    }
  }
}
