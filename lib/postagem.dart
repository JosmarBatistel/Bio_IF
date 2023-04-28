import 'package:cloud_firestore/cloud_firestore.dart';

class Postagem {
  String? nomeusuario;
  String? nome;
  String? descricao;
  String? tipo;
  String? dataHora;
  String? foto;
  String? localizacao;
  int? like;
  int? dislike;

  Postagem(
      {this.nomeusuario,
      this.nome,
      this.descricao,
      this.tipo,
      this.dataHora,
      this.foto,
      this.localizacao,
      this.like,
      this.dislike});

  Map<String, dynamic> toMap() {
    return {
      if (nomeusuario != null) "nome usuario": nomeusuario,
      if (nome != null) "nome": nome,
      if (descricao != null) "descricao": descricao,
      if (tipo != null) "tipo": tipo,
      if (dataHora != null) "data e hora": dataHora,
      if (foto != null) "foto": foto,
      if (localizacao != null) "localizacao": localizacao,
      if (like != null) "like": like,
      if (dislike != null) "dislike": dislike
    };
  }

  Postagem.fromJson(Map<String, dynamic> json)
      : nomeusuario = json["nome usuario"],
        nome = json["nome"],
        descricao = json["descricao"],
        tipo = json["tipo"],
        dataHora = json["data e hora"],
        foto = json["foto"],
        localizacao = json["localizacao"],
        like = json["like"],
        dislike = json["dislike"];

  //trazer dados que esta gravado na colecao do firebase
  factory Postagem.fromDocument(DocumentSnapshot doc) {
    final dados = doc.data()! as Map<String, dynamic>;
    return Postagem.fromJson(dados);
  }

  @override
  String toString() {
    return "Nome: $nome\n Descrição: $descricao\n Tipo: $tipo \n Data e Hora: $dataHora";
  }
}
