import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'An App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();


  void getNext(){
    current= WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }

  Future<String?> getWordFromBackend() async {
    //Boer:If testing android simulator, should use 10.0.2.2
    final response = await http.get(Uri.parse('http://10.0.2.2:5000/get-word'));
    // Boer: If not testing android simulator, should be localhost as below
    // final response = await http.get(Uri.parse('http://localhost:5000/get-word'));
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse['word'];
    } else {
      print('Failed to load word from backend');
      return 'FlaskFailed';
    }
  }

  void fetchNewWord() {
    getWordFromBackend().then((word) {
      if (word != null) {
        print(word); // or do something with the word
        // For simplicity, I'm updating the `current` variable with new word
        current = WordPair(word, '!'); // assuming WordPair can take a single string
        notifyListeners();
      }
    });
  }
}


class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('First buttom: random word'),
            Text('Second button: message from flutter'),
            BigCard(pair: pair),
            SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                appState.getNext();  // ← This instead of print().
              },
              child: Text('Next'),
            ),

            ElevatedButton(
              onPressed: () {
                appState.fetchNewWord();
              },
              child: Text('Fetch from Backend'),
            ),



          ],
        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme= Theme.of(context);

    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}