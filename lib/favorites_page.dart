import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'wordpair.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var favorites = appState.favorites;
    
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var favorite in favorites) // todo: only change word pair if first word is the id
              Column(
                children: [
                  TextPair(textPair: WordPair(" ", favorite.second)),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        appState.removeFavorite(favorite);
                      });
                    },
                    child: Text("Remove"),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ElevatedButton(
              onPressed: () {
                appState.saveFavorites(appState.favorites);
              },
              child: Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}