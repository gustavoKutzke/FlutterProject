import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projetodese/abas/AbaContatos.dart';
import 'package:projetodese/abas/AbaConversas.dart';

import 'Login.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{
  late TabController _tabController;
  List<String> itensMenu = [
    "Configurações","Deslogar"
  ];

  String _emailUsuario = "";

 Future _recuperarDadosUsuario()async{
   FirebaseAuth auth =FirebaseAuth.instance;
   User? usuarioLogado = await auth.currentUser;

  }

  Future _verificarUsuarioLogado()async{
    FirebaseAuth auth =FirebaseAuth.instance;

    User? usuarioLogado = await auth.currentUser;

    if(usuarioLogado ==null){
      Navigator.pushReplacementNamed(context,"/login");

    }
  }


  @override
  void initState() {

    super.initState();
    _verificarUsuarioLogado();
    _recuperarDadosUsuario();
    _tabController = TabController(length: 2, vsync: this);
  }
  _escolhaMenuItem(String itemEscolhido){
    switch(itemEscolhido){
      case "Configurações":
        Navigator.pushNamed(context,"/configuracoes");
        break;
      case "Deslogar":
        _deslogarUsuario();
        break;


    }
  }

  _deslogarUsuario() async{
    FirebaseAuth auth =FirebaseAuth.instance;
    await auth.signOut();

    Navigator.pushReplacementNamed(context,"/home");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Talk"),
        bottom: TabBar(

          indicatorWeight: 4,
          labelStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
          controller:_tabController,
          indicatorColor: Colors.white,
          tabs: <Widget>[
            Tab(text: "Conversas",),
            Tab(text: "Contatos",)
          ],
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _escolhaMenuItem,
            itemBuilder: (context){
              return itensMenu.map((String item){
                  return PopupMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
              }).toList();
            },
          )
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children:<Widget> [
          AbaConversas(),
          AbaContatos()
        ],
      ),
    );
  }
}
