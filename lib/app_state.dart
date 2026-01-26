import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'api.dart';
import 'dart:convert';


class MyAppState extends ChangeNotifier {
  WordPair current = WordPair.random();
  List<WordPair> favorites = []; 
  
  int loginIndex = 0; //sets login or sign up

  String accessToken = "";
  String refreshToken = "";

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
    if (accessToken.isEmpty) {
      print("token isn't set");
      print(accessToken);
      return;
    }
    
    try {
      final response = await ApiService.get("wordlist/", token: accessToken);

      for (var i in jsonDecode(response.body)) {
        favorites.add(WordPair(" ", i["wordlist"]));
      }
    } catch (e) {
      print("Error connecting to the server: $e");
      throw Exception("Couldn't read value");
    }
  }

  Future<void> saveFavorites(List<WordPair> word_pairs) async {
    if (accessToken.isEmpty) {
      print("Please login first");

    } else {
      for (var word_pair in word_pairs) {
        try {
          final response = await ApiService.post(
            "wordlist/",
            body: {
              "wordlist": word_pair.asString
            },
            token: accessToken
          );
          print(response.statusCode);
          print(response.body);
        } catch (e) {
          print("Error connecting to the server: $e");
          throw Exception("Couldn't read value");
        }
      }
    }
  }
}
