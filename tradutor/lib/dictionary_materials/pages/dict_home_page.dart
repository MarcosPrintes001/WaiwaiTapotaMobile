import 'package:flutter/material.dart';
import 'package:tradutor/dictionary_materials/models/model_dictionary.dart';
import 'package:tradutor/dictionary_materials/services/api_folders.dart';
import 'package:tradutor/dictionary_materials/utils/loading_widget.dart';
import 'package:tradutor/dictionary_materials/utils/word_tile.dart';
import "package:google_fonts/google_fonts.dart";

class DictHomePage extends StatefulWidget {
  const DictHomePage({super.key});

  @override
  State<DictHomePage> createState() => _DictHomePageState();
}

class _DictHomePageState extends State<DictHomePage> {
  final List<wordModel> _words = <wordModel>[];
  List<wordModel> _wordDisplay = <wordModel>[];
  final _scrollController = ScrollController();

  bool _isLoading = true;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    fetchWords(context).then((value) {
      if (value != null) {
        setState(() {
          _isLoading = false;
          _words.addAll(value);
          _wordDisplay = _words;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              "SEM CONEXÃO COM INTERNET",
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
        setState(() {
          _isLoading = false;
          _wordDisplay = [];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(166, 51, 41, 1),
        elevation: 0.0,
        title: const Text("Dicionario", textAlign: TextAlign.left),
        actions: [
          //Botão para atualizar o dicionario local
          TextButton.icon(
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              updateWords(context).then((value) {
                if (value != null) {
                  setState(() {
                    _isLoading = false;
                    _words.addAll(value);
                    _wordDisplay = _words;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.redAccent,
                      content: Text(
                        "SEM CONEXÃO COM INTERNET",
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  setState(() {
                    _isLoading = false;
                    _wordDisplay = _words;
                  });
                }
              });
            },
            icon: const Icon(
              color: Colors.white,
              Icons.download,
            ),
            label: const Text(
              "update",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _wordDisplay.length + 1,
          itemBuilder: (context, index) {
            if (!_isLoading) {
              return index == 0
                  ? _searchBar()
                  : WordTile(
                      word: _wordDisplay[index - 1],
                    );
            } else {
              return const LoadingView();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(166, 51, 41, 1),
        onPressed: () {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeIn,
          );
        },
        child: const Icon(Icons.arrow_upward),
      ),
    );
  }

  _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        style: GoogleFonts.openSans(
          color: Colors.black,
        ),
        autofocus: false,
        onChanged: (searchText) {
          searchText = searchText.toLowerCase();
          setState(() {
            _wordDisplay = _words.where((u) {
              var ptWord = u.meaningPort.toLowerCase();
              var waiWord = u.meaningWaiwai.toLowerCase();
              return ptWord.contains(searchText) ||
                  waiWord.contains(searchText);
            }).toList();
          });
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search),
          hintText: 'Buscar Palavras',
        ),
      ),
    );
  }
}
