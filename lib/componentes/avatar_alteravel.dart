import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resident/componentes/photocard.dart';

class AvatarAlteravel extends StatelessWidget {
  final String url;
  final double largura;
  final double altura;
  final Uint8List imagem;
  final Function aoBuscarImagem;
  final Function aoSelecionarImagem;
  final Function(Uint8List) aoTocarImagem;

  AvatarAlteravel(
    this.altura,
    this.largura,
    this.url,
    this.imagem, {
    this.aoBuscarImagem,
    this.aoTocarImagem,
    @required this.aoSelecionarImagem,
  });

  @override
  Widget build(BuildContext context) {
    Widget fotoCard = PhotoCard(
      url: url,
      bytes: imagem,
      largura: largura,
      altura: altura,
      aoExibir: aoTocarImagem,
    );
    return Stack(
      key: UniqueKey(),
      children: <Widget>[
        fotoCard,
        Positioned(
          right: 0,
          bottom: 0,
          child: ClipOval(
            child: Container(
              decoration: BoxDecoration(
                  gradient:
                      LinearGradient(colors: [Colors.blue, Colors.blueAccent])),
              child: IconButton(
                color: Colors.white,
                iconSize: 40,
                icon: Icon(
                  Icons.camera_alt,
                ),
                onPressed: () {
                  buscarImagem(ImageSource.camera);
                },
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          bottom: 0,
          child: RotatedBox(
            quarterTurns: 4,
            child: ClipOval(
              child: Container(
                decoration: BoxDecoration(
                    gradient:
                        LinearGradient(colors: [Colors.red, Colors.redAccent])),
                child: IconButton(
                  color: Colors.white,
                  iconSize: 40,
                  icon: Icon(
                    Icons.collections,
                  ),
                  onPressed: () {
                    buscarImagem(ImageSource.gallery);
                  },
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  buscarImagem(ImageSource deOnde) {
    if (aoBuscarImagem != null) {
      aoBuscarImagem();
    }
    ImagePicker.pickImage(source: deOnde).catchError((_) {
      aoSelecionarImagem(null);
    }).then((_) {
      aoSelecionarImagem(_);
    });
  }
}
