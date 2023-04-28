import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  String? id;
  String? nome;
  String? email;
  String? senha;

  Usuario({this.id, this.nome, this.email, this.senha});

  Map<String, dynamic> toMap() {
    return {
      if (id != null) "id": id,
      if (nome != null) "nome": nome,
      if (email != null) "email": email,
      if (senha != null) "senha": senha
    };
  }

  Usuario.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        nome = json["nome"],
        email = json["email"],
        senha = json["senha"];

  //trazer dados que esta gravado na colecao do firebase
  factory Usuario.fromDocument(DocumentSnapshot doc) {
    final dados = doc.data()! as Map<String, dynamic>;
    return Usuario.fromJson(dados);
  }

  @override
  String toString() {
    return "email: $email\n Descrição: $senha";
  }
}
