import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class TextPair extends StatelessWidget {
  const TextPair({super.key, required this.textPair});

  final WordPair textPair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); //get current theme of app
    final style = theme.textTheme.displayMedium!.copyWith(
      //copy current style and change color
      color: theme.colorScheme.onPrimary,
      fontSize: 30,
      letterSpacing: 4,
      wordSpacing: 40,
    );

    return Card(
      color: theme.colorScheme.primary, //change widget theme to current theme
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          textPair.asLowerCase,
          style: style,
          semanticsLabel: "${textPair.first}, ${textPair.second}",
        ),
      ),
    );
  }
}
