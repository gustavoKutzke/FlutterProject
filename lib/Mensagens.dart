import 'dart:ffi';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:projetodese/model/Mensagem.dart';
import 'package:projetodese/model/Usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Mensagens extends StatefulWidget {


  Usuario contato;
  Mensagens(this.contato);

  @override
  State<Mensagens> createState() => _MensagensState();
}

class _MensagensState extends State<Mensagens> {

  late String _idUsuarioLogado;
  late String _idUsuarioDestinatario;

  List<String> listMensagens = [
    "AAAAAAAAAAAAAAAAAAA",
    "BBBBBBBBBBBBBBB",
    "CCCCCCCCCCCCCCCCCCCCCC",
    "DDDDDDDDDDDDDDDDDDDDD",
    "EEEEEEEEEEEEEEEEEEE",
    "FFFFFFFFFFFFFFFFFFFFFF",
    "FFFFFFFFFFFFFFFFFFFFF",
  ];


  TextEditingController _controllerMensagem = TextEditingController();

  _enviarMensagem(){

    String textoMensagem =_controllerMensagem.text;
    if(textoMensagem.isNotEmpty){

    Mensagem mensagem = Mensagem();

    mensagem.idUsuario = _idUsuarioLogado;
    mensagem.mensagem = textoMensagem;
    mensagem.urlImagem = "";
    mensagem.tipo ="texto";

    _salvarMensagem(_idUsuarioLogado,_idUsuarioDestinatario,mensagem);

    }

  }

  _salvarMensagem(String idRemetente,String idDestinatario,Mensagem msg)async{
      FirebaseFirestore db =FirebaseFirestore.instance;
      await db.collection("mensagens")
    .doc(idRemetente)
    .collection(idDestinatario)
    .add(msg.toMap());



  }

  _enviarFoto(){

  }

  Future<dynamic> _recuperarDadosUsuario ( dynamic User) async {
    FirebaseAuth auth = await FirebaseAuth.instance;
    User = await auth.currentUser?.uid;


    dynamic usuarioLogado = User;
    _idUsuarioLogado = usuarioLogado;
    _idUsuarioDestinatario = widget.contato.idUsuario;



  }

  @override
  void initState() {
    _recuperarDadosUsuario(User);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var caixaMensagem = Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(child:
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: TextField(
              controller: _controllerMensagem,
              autofocus: true,
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                  contentPadding:EdgeInsets.fromLTRB(32, 16, 32, 16),
                  hintText: "Digite Uma Mensagem...",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),

                  ),
                prefixIcon: IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: _enviarFoto,
                )
              ),
            ),
          )
          ),
          FloatingActionButton(backgroundColor:Color(0xff075E54),
          child: Icon(Icons.send,color: Colors.white,),
            mini: true,
            onPressed:_enviarMensagem,

          )

        ],
      ),
    );

    var listView = Expanded(child:
    ListView.builder(
      itemCount: listMensagens.length,
        itemBuilder:(context,indice){

        double larguraContainer = MediaQuery.of(context).size.width *0.8;


        Alignment alinhamento = Alignment.centerRight;
        Color cor = Color(0xffd2ffa5);

        if(indice %2 == 0){
          cor = Colors.white;
          alinhamento = Alignment.centerLeft;
        }


          return Align(
            alignment:alinhamento,
            child: Padding(
              padding: EdgeInsets.all(6),
              child: Container(
                width: larguraContainer,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cor,
                  borderRadius: BorderRadius.all(Radius.circular(8))
                ),
                child: Text(
                  listMensagens[indice],
                style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          );
        }
    ),
    );

    return Scaffold(
      appBar: AppBar(
          title:Row(
            children: <Widget>[
              CircleAvatar(
                maxRadius: 20,
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(widget.contato.urlImagem),
              ),
              Padding(padding: EdgeInsets.only(left: 8),
              child: Text(widget.contato.nome),
              )
            ],
          )),
      body: Container(

        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("imagens/bg.png"),
            fit: BoxFit.cover
          )
        ),
        child: SafeArea(
          child:Container(
            padding: EdgeInsets.all(8),
            child:  Column(
              children:<Widget> [
                listView,
                caixaMensagem,

              ],
            ),
          )
        ),
      ),

    );
  }
}


