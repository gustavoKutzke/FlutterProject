
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projetodese/model/Usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {

  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _mensagemErro = "";

  _validarCampos(){
    String nome = _controllerNome.text;
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if(nome.isNotEmpty){
      if(email.isNotEmpty && email.contains("@")){
        if(senha.isNotEmpty && senha.length> 6){

          setState(() {
            _mensagemErro = "";
          });
          Usuario usuario = Usuario();
          usuario.nome = nome;
          usuario.senha = senha;
          usuario.email = email;

          _cadastrarUsuario(usuario);


        }else{
          setState(() {
            _mensagemErro = "Preencha a Senha! Digite mais de 6 Caracteres";
          });
        }
      }else{
        setState(() {
          _mensagemErro = "Preencha o Email Válido";
        });
      }
    }else{
      setState(() {
        _mensagemErro = "Preencha o Nome";
      });
    }
  }
  _cadastrarUsuario(Usuario usuario) async {

    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();



  FirebaseAuth auth = FirebaseAuth.instance;
  auth.createUserWithEmailAndPassword(email: usuario.email, password: usuario.senha).then((FirebaseUser){




    FirebaseFirestore db =FirebaseFirestore.instance;

      db.collection('Usuarios')
      .doc(auth.currentUser?.uid)
      .set(usuario.toMap());

    Navigator.pushNamedAndRemoveUntil(context, "/home", (_)=>false);

  }).catchError((error){
  setState(() {
  _mensagemErro = "Erro ao cadastrar usuário,verifique os campos e tente novamente";

  });
  });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro"),
      ),
      body: Container(
        decoration: BoxDecoration(color: Color(0xff075E54)),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children:<Widget>[
                Padding(padding: EdgeInsets.only(bottom: 32),
                  child: Image.asset(
                    "imagens/usuario.png",
                    width: 200,
                    height: 150,
                  ),
                ),
                Padding(padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerNome,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding:EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Nome",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32)
                        )
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding:EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "E-mail",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32)
                        )
                    ),
                  ),
                ),
                TextField(
                  controller: _controllerSenha,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding:EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Senha",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32)
                      )
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 16,bottom: 10),
                  child: ElevatedButton(
                    child: Text(
                      "Cadastrar",
                      style: TextStyle(color:Colors.white,fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        padding: EdgeInsets.fromLTRB(32, 16, 32, 16)
                    ),
                    onPressed:(){
                      _validarCampos();
                    },
                  ),
                ),
               Center(
                 child:  Text(_mensagemErro,
                   style: TextStyle(color: Colors.red,
                       fontSize: 20
                   ),
                 ),
               )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
