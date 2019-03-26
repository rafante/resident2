import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resident/entidades/paciente.dart';
import 'package:resident/entidades/usuario.dart';

class Grupo {
  static Grupo mostrado;
  static List<Grupo> lista = [];

  String id;
  String nome;
  String descricao;
  String urlFoto;
  List<dynamic> contatos;

  Grupo({this.id, this.nome, this.descricao, this.contatos, this.urlFoto}) {
    if (contatos == null) contatos = [Usuario.logado.uid];
  }

  void salvar() {
    if (id == null) {
      _criar();
      return;
    }
    _alterar();
  }

  void _criar() {
    var documento = Firestore.instance.collection('grupos').document();
    this.id = documento.documentID;
    lista.add(this);
    setData(documento);
  }

  void _alterar() {
    var documento = Firestore.instance.collection('grupos').document(id);
    setData(documento);
  }

  static List<dynamic> todosIds() {
    List<dynamic> ids = [];
    lista.forEach((grupo) {
      ids.add(grupo.id);
    });
    return ids;
  }

  List<Usuario> getUsuariosContatos() {
    if (contatos == null || contatos.length == 0) return [];
    List<Usuario> usuarios = [];
    contatos.forEach((contatoId) {
      Usuario contato = Usuario.buscaPorId(contatoId);
      if (contato != null) usuarios.add(contato);
    });
    return usuarios;
  }

  void setData(DocumentReference documento) {
    documento.setData({
      'nome': nome,
      'descricao': descricao,
      'contatos': contatos,
      'urlFoto': urlFoto
    });
  }

  static Grupo buscaPorId(String id) {
    if (lista == null || lista.length == 0) return null;
    return lista.firstWhere((grupo) {
      return grupo.id == id;
    }, orElse: () => null);
  }

  void setContatosPelosIds(List contatosSelecionados) {
    contatos = contatosSelecionados;
//    contatos.addAll(contatosSelecionados);
  }

  void deletar() {
    var pacientes = Paciente.porGrupo(id);
    pacientes.forEach((paciente) {
      paciente.deletar();
    });
    Firestore.instance.collection('grupos').document(id).delete();
    lista.remove(this);
  }
}
