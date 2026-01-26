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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var favorite in favorites)
            Column(
              children: [
                TextPair(textPair: favorite),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      favorites.remove(favorite);
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
              child: Text("Save")
          )
        ],
      ),
    );
  }
}