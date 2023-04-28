import 'package:bio_if/home.dart';
import 'package:bio_if/usuarioatual.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'cadastro.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String? _status = "";
  //String? _statusUsuario = "Usuário não logado";

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      return await _auth.signInWithCredential(credential);
    }
    return null;
  }

  Future _Login() async {
    var auth = FirebaseAuth.instance;
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    try {
      var usuario =
          await auth.signInWithEmailAndPassword(email: email, password: senha);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Home()));
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == "user-not-found") {
        setState(() {
          _status = "Email invalido!!";
        });
      } else if (e.code == "wrong-password") {
        setState(() {
          _status = "Senha invalida!!";
        });
      }
    }
  }

  void _logOut() async {
// fazer o try catch com mensagens personalizadas do logout
    await FirebaseAuth.instance.signOut();
    /*try {
      
    } on FirebaseAuthException catch (e) {
      
    }*/
  }

  void _telaCadastro() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Cadastro(),
        ));
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
        child: ListView(
          children: <Widget>[
            SizedBox(
              child: Image.asset("imagens/logo_login.png"),
              height: 250,
            ),
            SizedBox(
              height: 80,
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  labelText: "E-mail",
                  labelStyle: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  )),
              controller: _controllerEmail,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: "Senha",
                  labelStyle: TextStyle(
                      color: Colors.black38,
                      fontWeight: FontWeight.w400,
                      fontSize: 20)),
              controller: _controllerSenha,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              _status!,
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              height: 60,
              alignment: Alignment.centerLeft,
              color: const Color.fromARGB(255, 04, 82, 37),
              child: SizedBox.expand(
                child: TextButton(
                  onPressed: _Login,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Entrar",
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
            Padding(
              padding: EdgeInsets.all(2),
              child: TextButton(
                  onPressed: _telaCadastro,
                  child: const Text("Não tem cadastro? Clique aqui")),
            ),
            SizedBox(
              height: 50,
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.login),
              label: Text('Login com o Google'),
              onPressed: () async {
                final UserCredential? userCredential = await signInWithGoogle();
                if (userCredential != null) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Home()));
                  //O usuário está logado, faça alguma coisa
                } else {
                  print("Não deu");
                  // O usuário não está logado
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
