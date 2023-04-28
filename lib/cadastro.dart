import 'package:bio_if/login.dart';
import 'package:bio_if/usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//cadastro dos usuarios
class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  var db = FirebaseFirestore.instance;
  String? _status = "";

  Future _cadastrarUsuario() async {
    var auth = FirebaseAuth.instance;
    String nome = _controllerNome.text;
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    try {
      var usuario = await auth.createUserWithEmailAndPassword(
          email: email, password: senha);
      print(
          "usuario criado com sucesso: ID: ${usuario.user!.uid} - Email ${usuario.user!.email}");
      setState(() {
        _status = "Usuário criado com sucesso!!";
      });
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Login(),
          ));
      Usuario user = Usuario(
          id: usuario.user!.uid, nome: nome, email: email, senha: senha);
      db.collection("Usuario").doc(usuario.user!.uid).set(user.toMap());
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == "email-already-in-use") {
        setState(() {
          _status = "Email ja em uso!!";
        });
      } else if (e.code == "weak-password") {
        setState(() {
          _status = "Senha fraca!! Sua senha precisa ter 6 caracteres";
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.only(
        top: 60,
        left: 40,
        right: 40,
      ),
      child: ListView(children: <Widget>[
        Padding(
          padding: EdgeInsets.all(60),
          child: Text(
            "Cadastre-se",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 50,
        ),
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          controller: _controllerNome,
          decoration: InputDecoration(
              labelText: "Nome completo",
              labelStyle: TextStyle(
                color: Colors.black38,
                fontWeight: FontWeight.w400,
                fontSize: 20,
              )),
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          controller: _controllerEmail,
          decoration: InputDecoration(
              labelText: "E-mail",
              labelStyle: TextStyle(
                color: Colors.black38,
                fontWeight: FontWeight.w400,
                fontSize: 20,
              )),
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        TextFormField(
          keyboardType: TextInputType.text,
          obscureText: true,
          controller: _controllerSenha,
          decoration: InputDecoration(
              labelText: "Senha",
              labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20)),
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(
          height: 30,
        ),
        Text(_status!,
            style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
        SizedBox(
          height: 50,
        ),
        Container(
          height: 60,
          alignment: Alignment.centerLeft,
          color: Colors.green[100],
          child: SizedBox.expand(
            child: TextButton(
              onPressed: _cadastrarUsuario,
              child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Cadastrar",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ]),
            ),
          ),
        ),
      ]),
    ));
  }
}
