import 'package:flutter/material.dart';

import 'screens/news_list.dart';
import 'blocs/stories_bloc/stories_provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // MatrialApp 이하의 모든 Widget 에서 StoriesBloc 을 사용 가능하게 만듬.
    return StoriesProvider(
      child: const MaterialApp(
        title: 'News',
        debugShowCheckedModeBanner: false,
        home: NewsList(),
      ),
    );
  }
}
