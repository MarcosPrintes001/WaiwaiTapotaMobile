// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tradutor/dictionary_materials/models/model_dictionary.dart';
import 'package:tradutor/dictionary_materials/services/api_folders.dart';

class WordPage extends StatefulWidget {
  final wordModel word;
  const WordPage({super.key, required this.word});

  @override
  State<WordPage> createState() => _WordPageState();
}

class _WordPageState extends State<WordPage> {
  var imageErro = "assets/noImage.png";
  var _imageUrl;
  String? _imageError;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();

    try {
      getWordData(widget.word.wodrId).then((value) {
        if (value != null && value != 404) {
          setState(() {
            _imageUrl = value;
          });
        } else if (value == 404) {
          setState(() {
            _imageError =
                "⚠ Erro ao carregar imagem. \nVerifique sua conexão e tente novamente!";
          });
        } else {
          setState(() {
            _imageError =
                '⚠ Erro ao carregar imagem. \nEsta palavra não possui imagem ainda!';
          });
        }
      });
    } catch (err) {
      setState(() {
        _imageError = 'Erro ao carregar imagem';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(166, 51, 41, 1),
        centerTitle: true,
        title: const Text("Significado"),
        elevation: 0.0,
        actions: const [],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            Center(
              child: Column(
                children: [
                  //Imagem
                  _imageUrl == null
                      ? Column(
                          children: [
                            if (_imageError != null)
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image(image: AssetImage(imageErro)),
                                  Positioned.fill(
                                    child: Container(
                                      padding: const EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.8),
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      child: Text(
                                        _imageError.toString(),
                                        style: const TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            if (_imageError == null)
                              Column(
                                children: const [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 16),
                                  Text('Carregando imagem...')
                                ],
                              ),
                          ],
                        )
                      : Image.memory(
                          Uint8List.fromList(_imageUrl),
                          fit: BoxFit.cover,
                        ),

                  const SizedBox(height: 20),
                  //Titulo Waiwai
                  Text(widget.word.meaningWaiwai.toString().toUpperCase(),
                      style: GoogleFonts.openSans(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ))
                ],
              ),
            ),
            //Significados
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Significado Portuges
                    Row(
                      children: [
                        Expanded(
                          child: RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 28,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text: "Significado: ",
                                    style: GoogleFonts.openSans(
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                  text: widget.word.meaningPort,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                const TextSpan(
                                    text: "Fonema: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(
                                  text: widget.word.fonema,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                const TextSpan(
                                    text: "Sinonimo Pt: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(
                                  text: widget.word.synonymPort,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                const TextSpan(
                                    text: "Sinonimo Wai: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(
                                  text: widget.word.synonymWaiwai,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    Row(
                      children: [
                        Expanded(
                          child: RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                const TextSpan(
                                    text: "Comentário: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(
                                  text: widget.word.exampleSentence,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
