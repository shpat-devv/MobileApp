import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'api.dart';
import 'dart:convert';


class MyAppState extends ChangeNotifier {
  WordPair current = WordPair.random();
  List<WordPair> favorites = []; 
  
  //the indexes of the start and end of the old favorite word pairs so we dont send them over again
  int oldStartIndex = 0;
  int oldEndIndex = 0;

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
      return;
    }
    
    try {
      final response = await ApiService.get("wordlist/", token: accessToken);

      oldStartIndex = favorites.length;
      for (var i in jsonDecode(response.body)) {
        favorites.add(WordPair("${i["id"]}", i["wordlist"]));
      }
      oldEndIndex = favorites.length; 
      print("start index of old fav: $oldStartIndex, end index: $oldEndIndex");
    } catch (e) {
      print("Error connecting to the server: $e");
      throw Exception("Couldn't read value");
    }
  }

  Future<void> removeFavorite(WordPair favorite) async {
    if (isNumeric(favorite.first)) {
        try {
            final response = await ApiService.delete(
              "wordlist/delete/${int.parse(favorite.first)}/",
              token: accessToken
            );
            print(response.statusCode);
            print(response.body);
          } catch (e) {
            print("Error connecting to the server: $e");
            throw Exception("Couldn't read value");
          }
   }
    favorites.remove(favorite);
  }

  Future<void> saveFavorites(List<WordPair> wordPairs) async {
    if (accessToken.isEmpty) {
      print("Please login first");
    } else {
      for (int i = 0; i < wordPairs.length; i++) {
        if (i > oldStartIndex && i < oldEndIndex) {
          print("ignoring: ${wordPairs[i].asString} because its already saved");
        } else {
          try {
            final response = await ApiService.post(
              "wordlist/",
              body: {
                "wordlist": wordPairs[i].asString.replaceAll(' ', '')
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
}

// Source - https://stackoverflow.com/q
// Posted by scrblnrd3, modified by community. See post 'Timeline' for change history
// Retrieved 2026-01-27, License - CC BY-SA 3.0

bool isNumeric(String str) {
  try{
    var value = double.parse(str);
  } on FormatException {
    return false;
  } finally {
    return true;
  }
}