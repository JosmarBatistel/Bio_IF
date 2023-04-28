import 'dart:io';

import 'package:bio_if/home.dart';
import 'package:bio_if/postagem.dart';
import 'package:bio_if/sobre.dart';
import 'package:bio_if/usuario.dart';
import 'package:bio_if/usuarioatual.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'ajuda.dart';
import 'cadastro.dart';
import 'login.dart';
import 'mapa.dart';

/*cadastro das especies
  -nome conhecido da especies
  -descricao
  -tipo
  -data
  -localização
  -foto
  -likes e deslikes
  -usuario que publicou
*/

class Especies extends StatefulWidget {
  String LatLongStr;
  Especies(this.LatLongStr, {super.key});
  //Especies(this.LatLongStr, {super.key});

  @override
  State<Especies> createState() => _EspeciesState();
}

class _EspeciesState extends State<Especies> {
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerDescricao = TextEditingController();
  String? _campoSelecionado = "";
  String _resultado = "";
  XFile? _arquivoImagem;
  String? dataHora = DateTime.now().toString();
  var db = FirebaseFirestore.instance;
  String? _urlImagem = null;
  String? _status = "Postagem não realizada";
  int? contagem = 0;
  String? nomeUsuario = "";

  Future _capturaFoto(bool daCamera) async {
    final ImagePicker picker = ImagePicker();
    XFile? imagem;

    if (daCamera) {
      imagem = await picker.pickImage(source: ImageSource.camera);
    } else {
      imagem = await picker.pickImage(source: ImageSource.gallery);
    }

    setState(() {
      _arquivoImagem = imagem;
    });
  }

  void _selecao() {
    if (_campoSelecionado == "") {
      setState(() {
        _resultado = "Não Informado";
      });
    } else if (_campoSelecionado == 'P') {
      setState(() {
        _resultado = "Planta";
      });
    } else {
      setState(() {
        _resultado = "Animal";
      });
    }
  }

  _formatarData(String data) {
    initializeDateFormatting("pt_BR");
    var formatador = DateFormat.yMd("pt_BR");

    DateTime dataConvertida = DateTime.parse(data);

    return formatador.format(dataConvertida);
  }

  _adicionarLocal() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => Mapa()));
  }

  _pegarlocalizacao() async {}

  Future _postagem() async {
    if (UsuarioAtual().currentUser == null) {
      setState(() {
        _status = "Para fazer postagens você precisa estar logado";
      });
    } else {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference pastaRaiz = storage.ref();
      Reference arquivo = pastaRaiz
          .child("fotos")
          .child(DateTime.now().millisecondsSinceEpoch.toString());

      UploadTask task = arquivo.putFile(File(_arquivoImagem!.path));

      task.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
        if (taskSnapshot.state == TaskState.running) {
          setState(() {
            _status = "Realizando postagem";
          });
        } else if (taskSnapshot.state == TaskState.success) {
          _recuperarImagem(taskSnapshot);
          setState(() {
            _status = "Postagem realizada com sucesso";
          });
        } else if (taskSnapshot.state == TaskState.error) {
          setState(() {
            _status = "Erro. Tente novamente";
          });
        }
      });
    }
  }

  Future _recuperarImagem(TaskSnapshot taskSnapshot) async {
    String url = await taskSnapshot.ref.getDownloadURL();
    print("URL: $url");

    setState(() {
      _urlImagem = url;
    });

    _selecao();

    Postagem postagem = Postagem(
        nomeusuario: UsuarioAtual().currentUser?.email,
        nome: _controllerNome.text,
        descricao: _controllerDescricao.text,
        tipo: _resultado,
        dataHora: _formatarData(dataHora!),
        foto: _urlImagem,
        localizacao: widget.LatLongStr,
        like: contagem,
        dislike: contagem);

    db.collection("Postagem").add(postagem.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 04, 82, 37),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text("Cadastro das Espécies"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                "Cadastro de Espécies",
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              const Text(
                "Tipo da Espécie:",
                style: TextStyle(fontSize: 20),
              ),
              RadioListTile(
                  title: const Text("Planta"),
                  value: "P",
                  groupValue: _campoSelecionado,
                  onChanged: (String? resultado) {
                    setState(() {
                      _campoSelecionado = resultado;
                    });
                  }),
              RadioListTile(
                  title: const Text("Animal"),
                  value: "A",
                  groupValue: _campoSelecionado,
                  onChanged: (String? resultado) {
                    setState(() {
                      _campoSelecionado = resultado;
                    });
                  }),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: "Nome Popular",
                  hintStyle: TextStyle(fontSize: 20),
                ),
                controller: _controllerNome,
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 150,
                ),
                child: TextFormField(
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: "Descrição",
                    hintStyle: TextStyle(fontSize: 20),
                  ),
                  controller: _controllerDescricao,
                ),
              ),
              SizedBox(
                height: 30,
              ),

              //Row(children: [

              const Text(
                "Imagem:",
                style: TextStyle(fontSize: 30),
              ),

              _arquivoImagem != null
                  ? Image.file(
                      File(_arquivoImagem!.path),
                      fit: BoxFit.cover,
                    )
                  : Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.folder),
                    onPressed: () {
                      _capturaFoto(false);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: () {
                      _capturaFoto(true);
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  _adicionarLocal();
                },
                label: Text("Localização"),
                icon: Icon(Icons.add_location_alt_rounded),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 04, 82, 37)),
              ),
              SizedBox(
                height: 80,
              ),
              Container(
                height: 60,
                alignment: Alignment.bottomCenter,
                color: const Color.fromARGB(255, 04, 82, 37),
                child: SizedBox.expand(
                  child: TextButton(
                    onPressed: _postagem,
                    child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Enviar",
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
              Text(_status!),
            ],
          ),
        ),
      ),
    );
  }
}
