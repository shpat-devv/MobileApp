import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';


class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var favorites = <WordPair>[]; //a list that can only contain word pairs

  void getNext() {
    current = WordPair.random();
    notifyListeners(); //make sure all the widgets using current get notified
  }

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}