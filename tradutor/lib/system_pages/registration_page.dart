// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tradutor/dictionary_materials/services/api_folders.dart';
import 'package:tradutor/dictionary_materials/utils/util.dart';

import 'login_page.dart';
import 'splash_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({
    Key? key,
  }) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formkey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _emaiController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirSenhaController = TextEditingController();
  bool _verSenha = false;
  bool _verSenhaConfirm = false;

  Color alertColor = Colors.orange;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover, image: AssetImage("assets/backGroud.png"))),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //LOGO
                    const Image(
                      image: AssetImage('assets/tapotaLogo.png'),
                      height: 200,
                    ),
                    //TITLE

                    const SizedBox(
                      height: 70,
                    ),
                    //USER TEXT FIELD
                    TextFormField(
                      controller: _userNameController,
                      decoration: InputDecoration(
                          label: const Text('Nome de usuario'),
                          hintText: 'Eduardo Silva',
                          filled: true,
                          fillColor: Colors.white,
                          errorStyle: TextStyle(color: alertColor)),
                      validator: (email) {
                        if (email == null || email.isEmpty) {
                          return 'Digite um nome de usuario';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //EMAIL TEXT FIELD
                    TextFormField(
                      textCapitalization: TextCapitalization.words,
                      controller: _emaiController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          label: const Text('e-mail'),
                          hintText: 'eduardo@email.com',
                          filled: true,
                          fillColor: Colors.white,
                          errorStyle: TextStyle(color: alertColor)),
                      validator: (email) {
                        if (email == null || email.isEmpty) {
                          return 'Digite seu email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //SENHA TEXT FIELD
                    TextFormField(
                      controller: _senhaController,
                      obscureText: !_verSenha,
                      decoration: InputDecoration(
                        errorStyle: TextStyle(color: alertColor),
                        suffixIcon: IconButton(
                          icon: Icon(_verSenha
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined),
                          onPressed: () {
                            setState(() {
                              _verSenha = !_verSenha;
                            });
                          },
                        ),
                        label: const Text('senha'),
                        hintText: 'Digite uma senha',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (senha) {
                        if (senha == null || senha.isEmpty) {
                          return 'Digite uma senha';
                        } else if (senha.length < 6) {
                          return 'Digite uma senha mais forte';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    //Confirm SENHA TEXT FIELD
                    TextFormField(
                      controller: _confirSenhaController,
                      obscureText: !_verSenhaConfirm,
                      decoration: InputDecoration(
                        errorStyle: TextStyle(color: alertColor),
                        suffixIcon: IconButton(
                          icon: Icon(_verSenhaConfirm
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined),
                          onPressed: () {
                            setState(() {
                              _verSenhaConfirm = !_verSenhaConfirm;
                            });
                          },
                        ),
                        label: const Text('Confirme sua senha'),
                        hintText: 'Digite uma senha',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (senha) {
                        if (senha == null || senha.isEmpty) {
                          return 'Digite uma senha';
                        }
                        if (_senhaController.text.trim() !=
                            _confirSenhaController.text.trim()) {
                          return 'Senhas Não Coincidem';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    //BOTÂO LOGAR
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          minimumSize: const Size(40, 40)),
                      onPressed: () async {
                        if (_formkey.currentState!.validate()) {
                          try {
                            var responseCad = await cadastro(_senhaController,
                                _userNameController, _emaiController);

                            if (responseCad.statusCode == 201) {
                              //cadastro aceito

                              await login(_emaiController.text.toString(),
                                      _senhaController.text.toString())
                                  .then(
                                (value) async {
                                  
                                  if (value.statusCode  == 200) {
                                    bool resp = await setLogin(
                                        value,
                                        _senhaController.text,
                                        _emaiController.text);
                                    if (resp) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const SplashPage(),
                                        ),
                                      );
                                    }
                                  }
                                  //chamar tela home
                                },
                              );
                            } else if (responseCad.statusCode == 400) {
                              //usuario ja existe
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(
                                    "Email ou Nome de Usuario já cadastrado",
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(
                                    "CADASTRO FALHOU",
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.redAccent,
                                content: Text(
                                  "ERRO DE CONEXÃO",
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        }
                      },
                      child: const Text(
                        "CADASTRAR",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //REGISTRAR AGORA
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Já tem conta?",
                          style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontWeight: FontWeight.bold), //GoogleFonts
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const LoginPage();
                            }));
                          },
                          child: Text(
                            " Logar Agora",
                            style: GoogleFonts.roboto(
                                color: Colors.lightBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
