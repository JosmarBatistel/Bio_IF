import 'package:flutter/material.dart';

class Sobre extends StatefulWidget {
  const Sobre({super.key});

  @override
  State<Sobre> createState() => _SobreState();
}

class _SobreState extends State<Sobre> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sobre"),
          backgroundColor: const Color.fromARGB(255, 04, 82, 37),
        ),
        body: SingleChildScrollView(
          child:
              // ignore: prefer_const_literals_to_create_immutables
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const Padding(
              padding: EdgeInsets.all(30),
              child: Text(
                "Bem vindo ao Bio IF!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                "Com o aplicativo você é capaz de registar animais e plantas que encontrar através de fotos e demais "
                "informações, como nome e um texto descritivo.",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.justify,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                "Você também pode registrar a localização em que a imagem foi capturada utilizando o GPS do seu dispositivo móvel, clicando no botão ADICIONAR LOCALIZAÇÃO e mantendo pressionado por um tempo a localização correta no mapa.",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.justify,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                  "Para criar uma publicação será necessário realizar seu login, caso não possua conta, clique no botão CADASTRE-SE.",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.justify),
            ),
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                "As publicações possuem a opção de LIKE e DESLIKE, opções que são possíveis após o login, sendo que se uma publicação receber mais de 60% de DESLIKES provavelmente possui informações erradas e devem ser revisadas.",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.justify,
              ),
            ),
          ]),
        ));
  }
}
