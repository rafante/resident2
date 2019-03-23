import 'package:flutter/material.dart';
import 'package:resident/entidades/paciente.dart';
import 'package:resident/paginas/home_page.dart';
import 'package:resident/utils/tela.dart';

class HDAPage extends StatefulWidget {
  @override
  _HDAPageState createState() => _HDAPageState();
}

class _HDAPageState extends State<HDAPage> {
  TextEditingController hdaController = TextEditingController(text: '');

  @override
  void initState() {
    hdaController.text = Paciente.mostrado.hdaString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: getCorpo(),
      floatingActionButton: getBotaoSalvar(),
    );
  }

  Widget getAppBar() {
    return AppBar(
      title: getTitulo(),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          HomePage.mudarPagina(Paginas.PACIENTE);
        },
      ),
    );
  }

  Widget getTitulo() {
    return Text('História da Doença Atual');
  }

  Widget getCorpo() {
    return Form(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Tela.x(context, 5), vertical: Tela.y(context, 5)),
        child: ListView(children: getListaCampos()),
      ),
    );
  }

  Widget getBotaoSalvar() {
    return FloatingActionButton(
      onPressed: () {
        salvar();
        voltar();
      },
    );
  }

  List<Widget> getListaCampos() {
    return [getHistoricoDoencaAtual()];
  }

  Widget getHistoricoDoencaAtual() {
    return TextFormField(
      controller: hdaController,
      style: getEstiloCampo(),
      decoration: getDecoracaoCampo(label: ''),
    );
  }

  TextStyle getEstiloCampo() {
    return TextStyle();
  }

  InputDecoration getDecoracaoCampo({String label}) {
    return InputDecoration(
      border: OutlineInputBorder(),
      labelText: label,
      filled: true,
      fillColor: Colors.white,
    );
  }

  void salvar() {
    Paciente.mostrado.hda = [];
    Paciente.mostrado.hda.add(hdaController.text);
    Paciente.mostrado.salvar();
  }

  void voltar() {
    HomePage.mudarPagina(Paginas.PACIENTE);
  }
}
