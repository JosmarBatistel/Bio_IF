import 'dart:async';
import 'dart:developer';

import 'package:bio_if/cadastro.dart';
import 'package:bio_if/especies.dart';
import 'package:bio_if/postagem.dart';
import 'package:bio_if/sobre.dart';
import 'package:bio_if/login.dart';
import 'package:bio_if/usuarioatual.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ajuda.dart';

//listagem das especies
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var db = FirebaseFirestore.instance;
  String latlong = "";
  String? _statusLogin = "";
  List<String> itensMenu = ["Sobre", "Ajuda", "Sair"];
  int likeCount = 0;
  late final FirebaseFirestore _db;

  @override
  void initState() {
    super.initState();
    _db = FirebaseFirestore.instance;
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late CollectionReference _itemsRef;
  late Stream<QuerySnapshot> _itemsStream;

  _escolhaMenuItem(String itemEscolhido) {
    switch (itemEscolhido) {
      case "Sobre":
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Sobre()));
        break;
      case "Ajuda":
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Ajuda()));
        break;
      case "Sair":
        SystemNavigator.pop();
        break;
      default:
    }
  }

  //nao ta funcionando
  Future _like() async {
    db.collection("Postagem").doc().update({"like": FieldValue.increment(1)});
  }

  //nao ta funcionando
  Future _dislike() async {
    db
        .collection("Postagem")
        .doc()
        .update({"dislike": FieldValue.increment(1)});
  }

  /*void usuarioLogado() {
    if (UsuarioAtual().currentUser!.email == null) {
      setState(() {
        _statusLogin = "Usuário não logado";
      });
    } else {
      setState(() {
        _statusLogin = "${UsuarioAtual().currentUser!.email}";
      });
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 04, 82, 37),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 80,
        title: Text("Bio IF"),
        /*${UsuarioAtual().currentUser!.email}),*/
        /*Image.asset(
          'imagens/logo.png',
          height: 22,
        ),*/
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return itensMenu.map((String item) {
                return PopupMenuItem(value: item, child: Text(item));
              }).toList();
            },
            onSelected: _escolhaMenuItem,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Postagem")
                    .orderBy("data e hora", descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    final snap = snapshot.data!.docs;
                    return ListView.separated(
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                      shrinkWrap: true,
                      primary: false,
                      itemCount: snap.length,
                      itemBuilder: (context, index) {
                        return Column(children: [
                          Container(
                            margin: const EdgeInsets.all(5),
                            alignment: Alignment.center,
                            child: Text(
                              snap[index]['nome'].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 40,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(5),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Usuário: ${snap[index]['nome usuario']}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(5),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Descrição: ${snap[index]['descricao']}",
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(5),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "${snap[index]['tipo']}",
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(20),
                            alignment: Alignment.center,
                            child: Image.network(
                              snap[index]['foto'],
                            ),
                          ),
                          Container(
                              alignment: Alignment.center,
                              child: Text(
                                "Data: ${snap[index]['data e hora']}",
                              )),
                          Container(
                            margin: const EdgeInsets.all(5),
                            alignment: Alignment.center,
                            child: Text(
                              "Localização: ${snap[index]['localizacao']}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    snap[index]['dislike'].toString(),
                                  )),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final doc = await _db
                                  .collection('Postagem')
                                  .doc('DocumentReference doc')
                                  .get();
                              final likes = doc.get('like') ?? 0;

                              await _db
                                  .collection('Postagem')
                                  .doc('ChNvahpPAi0lGFQprsu3')
                                  .update({'like': likes + 1});

                              setState(() {
                                likeCount = likes + 1;
                              });
                            },
                            child: Row(
                              children: [
                                Icon(Icons.thumb_up),
                                SizedBox(width: 8),
                                Text("$likeCount"),
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.black,
                            indent: 20,
                            endIndent: 20,
                          )
                        ]);
                      },
                    );
                  } else {
                    return const Padding(
                        padding: EdgeInsets.all(150),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ));
                  }
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Nova Publicação"),
        extendedTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        icon: Icon(Icons.yard),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Especies(latlong)));
        },
        backgroundColor: const Color.fromARGB(255, 04, 82, 37),
        foregroundColor: Colors.white,
      ),
    );
  }
}
