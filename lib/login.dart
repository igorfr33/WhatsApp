

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/cadastro.dart';
import 'package:whatsapp/home.dart';
import 'package:whatsapp/model/usuario.dart';

class Login extends StatefulWidget {
  const Login({ Key key }) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _mensagemErro = "";

  validarCampos(){

    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if( email.isNotEmpty && email.contains("@") ){

        if( senha.isNotEmpty ){

          setState(() {
            _mensagemErro = "";
          });

          Usuario usuario = Usuario();

          usuario.email = email;
          usuario.senha = senha;

          _logarUsuario(usuario);

        }else{
          setState(() {
            _mensagemErro = "Preencha a senha!";
          });
        }

      }else{
        setState(() {
          _mensagemErro = "Preencha o E-mail utilizando @";
        });
      }

  }

  _logarUsuario(Usuario usuario){

    FirebaseAuth auth = FirebaseAuth.instance;

    auth.signInWithEmailAndPassword
    (email: usuario.email, password: usuario.senha
    ).then((FirebaseUser){

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home())
        );

    }).catchError((error){

      setState(() {
        _mensagemErro = "Erro ao autenticar usuário, verifique e-mail e senha."; 
      });

    });

  }

  Future verificarUsuarioLogado() async {

    FirebaseAuth auth = FirebaseAuth.instance;

    FirebaseUser usuarioLogado = await auth.currentUser();
    if( usuarioLogado != null ){

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home())
        );
    }

  }

  @override
  void initState() {
    verificarUsuarioLogado();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xff075E54),
        ),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Image.asset("images/logo.png", width: 200, height: 150,),
                  ),
                  Padding(
                    padding:EdgeInsets.only(bottom: 8),
                    child: TextField(
                      controller: _controllerEmail,
                      autofocus:true,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: "E-mail",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                      ),
                    ),
                    TextField(
                      obscureText: true,
                      controller: _controllerSenha,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: "Senha",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16, bottom: 10), 
                        child: RaisedButton(
                          color: Colors.green,
                          padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          onPressed: (){
                            validarCampos();
                          },
                          child: Text(
                            "Entrar",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          ),
                          ),
                          Center(
                            child: GestureDetector(
                              child: Text(
                                "Não tem conta? cadastre-se",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Cadastro()));
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Center(
                           child:  Text(
                            _mensagemErro,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                            ),
                          ),
                         ),
                            ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}