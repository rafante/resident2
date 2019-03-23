import 'package:flutter/material.dart';
import 'package:resident/componentes/foto_card.dart';
import 'package:resident/entidades/grupo.dart';
import 'package:resident/entidades/usuario.dart';
import 'package:resident/paginas/home_page.dart';
import 'package:resident/utils/cores.dart';
import 'package:resident/utils/tela.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GruposPage extends StatefulWidget {
  GruposPage();

  @override
  _GruposPageState createState() => _GruposPageState();
}

class _GruposPageState extends State<GruposPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: Text('Grupos'),
      ),
      body: listaGrupos(),
      drawer: Drawer(
        child: Column(
          children: drawerItens(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color(Cores.FLOATING_BUTTON_BACKGROUND),
          foregroundColor: Color(Cores.FLOATING_BUTTON_FOREGROUND),
          elevation: 8,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            Grupo.mostrado = null;
            HomePage.mudarPagina(Paginas.GRUPO_CONFIG);
//              deslogar();
          }),
    );
  }

  List<Widget> drawerItens() {
    TextStyle estilo = TextStyle(fontSize: 15);
    return [
      getDrawerHeader(),
      ListTile(
        title: Text(
          'Contatos',
          style: estilo,
        ),
        leading: Icon(Icons.group),
        onTap: () {
          Navigator.pop(context);
          HomePage.mudarPagina(Paginas.CONTATOS);
        },
      ),
      Expanded(
        child: Container(),
      ),
      ListTile(
        title: Text('Sair'),
        leading: Icon(Icons.clear),
        onTap: (){
          Usuario.deslogar();
          HomePage.mudarPagina(Paginas.LOGIN);
        },
      )
    ];
  }

  Widget listaGrupos() {
    if (Grupo.lista == null) return Container();
    List<Widget> gruposCard = [];
    Grupo.lista.forEach((grupo) {
      gruposCard.add(cardGrupo(grupo));
    });
    return ListView(
      children: gruposCard,
    );
  }

  void deslogar() {
    SharedPreferences.getInstance().then((_) {
      setState(() {
        _.remove('usuarioLogado');
      });
    });
  }

  Widget cardGrupo(Grupo grupo) {
    var fotoGrupo = FotoCard(grupo.urlFoto, 80, 80);
    Widget textoGrupo = Expanded(
      child: MaterialButton(
          child: Text(grupo.nome),
          onPressed: () {
            Grupo.mostrado = grupo;
            HomePage.mudarPagina(Paginas.PACIENTES);
          }),
    );
    Widget configuracoesGrupo = RaisedButton(
      shape: CircleBorder(),
      color: Colors.white,
      child: Icon(Icons.build),
      onPressed: () {
        Grupo.mostrado = grupo;
        HomePage.mudarPagina(Paginas.GRUPO_CONFIG);
      },
    );
    List<Widget> lista = [fotoGrupo, textoGrupo, configuracoesGrupo];
    return Card(
      key: Key(grupo.id),
      elevation: 5,
      child: Container(
        height: 80,
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: lista,
          ),
        ),
      ),
    );
  }

  Widget getDrawerHeader() {
    return UserAccountsDrawerHeader(
      accountName: Text(Usuario.logado.getIdentificacao()),
      currentAccountPicture: FotoCard(
          Usuario.logado.urlFoto, Tela.x(context, 10), Tela.y(context, 10)),
      accountEmail: Text('fulano@gmail.com'),
      onDetailsPressed: (){
        Navigator.of(context).pop();
        HomePage.mudarPagina(Paginas.PERFIL);
      },
    );
  }
}
