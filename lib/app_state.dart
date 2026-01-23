import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'api.dart';

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var favorites = <WordPair>[]; //a list that can only contain word pairs
  var loginIndex = 0; //sets login or sign up

  var accessToken = "";
  var refreshToken = "";

  void setLoginIndex(int index) {
    loginIndex = index;
    notifyListeners();
  } 

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

  Future<void> getFavorites() async {
    try {
      final response = await ApiService.get("wordlist/");
      print(response.statusCode);
      print(response.body);
    } catch (e) {
      print("Error connecting to the server: $e");
      throw Exception("Couldn't read value");
    }
  }

  Future<void> sentFavorites(body) async {
    try {
      final response = await ApiService.post(
        "wordlist/",
        body: body
      );
      print(response.statusCode);
    } catch (e) {
      print("Error connecting to the server: $e");
      throw Exception("Couldn't read value");
    }
  }
}
