import 'package:flutter/material.dart';

import 'screens/news_list.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'News',
      home: NewsList(),
    );
  }
}
