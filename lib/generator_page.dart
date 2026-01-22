import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'wordpair.dart';

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var textPair = appState.current; //only use the text pair and ignore the rest of app state

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextPair(textPair: textPair),
          SizedBox(height: 20),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text("Next"),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  appState.toggleFavorite();
                },
                child: Text("Like"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}