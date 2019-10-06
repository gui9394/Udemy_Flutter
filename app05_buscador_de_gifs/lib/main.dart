import 'package:flutter/material.dart';

import 'package:app05_buscador_de_gifs/ui/home_page.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
    theme: ThemeData(
      highlightColor: Colors.white,
      hintColor: Colors.white,
      primaryColor: Colors.white
    ),
  ));
}