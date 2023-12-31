class Mensagem{
  late String _idUsuario;
  late String _mensagem;
  late String _urlImagem;
  late String _tipo;

  Mensagem();

  Map<String,dynamic> toMap(){

    Map<String,dynamic> map = {
      "idUsuario" :this.idUsuario,
      "email":this.mensagem,
      "urlImagem":this.urlImagem,
      "tipo":this.tipo,
    };

    return map;
  }


  String get tipo => _tipo;

  set tipo(String value) {
    _tipo = value;
  }

  String get urlImagem => _urlImagem;

  set urlImagem(String value) {
    _urlImagem = value;
  }

  String get mensagem => _mensagem;

  set mensagem(String value) {
    _mensagem = value;
  }

  String get idUsuario => _idUsuario;

  set idUsuario(String value) {
    _idUsuario = value;
  }
}