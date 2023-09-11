import 'package:flutter/material.dart'; // 내부적으로 Navigator 를 가지고 있음.

import 'screens/news_list.dart';
import 'blocs/stories_bloc/stories_provider.dart';
import 'screens/news_detail.dart';
import 'blocs/comments/comments_provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // MatrialApp 이하의 모든 Widget 에서 StoriesBloc 을 사용 가능하게 만듬.
    return CommentsProvider(
      child: StoriesProvider(
        child: MaterialApp(
          title: 'News',
          debugShowCheckedModeBanner: false,
          // home: NewsList(),
          onGenerateRoute: route, // 객체 생성이 아니라 함수 참조
        ),
      ),
    );
  }

  // 너무 Nesting 이 깊어지지 않도록 함수로 추출
  Route route(RouteSettings settings) {
    // Navigator.pushNamed() 에서 정한 name 과 동일함.
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (context) => const NewsList(),
        );

      case '/detail':
      default:
        return MaterialPageRoute(
          builder: (context) {
            // extratct the item id from settings.name
            // and pass it into the NewsDetail widget
            //   a location to do some initialization
            //   or data fetching for the NewsDetail widget.

            final itemId = int.parse(settings.name!.replaceFirst('/', ''));
            // 상세정보의 댓글 조회를 위해 sink.add() 로 stream event를 발생시킴
            final commentsBloc = CommentsProvider.of(context);
            commentsBloc.addFetchItemWithComments(itemId);

            return NewsDetail(itemId: itemId);
          },
        );
    }
  }
}
