import 'package:flutter/material.dart';
import 'package:news/src/blocs/stories_bloc/stories_provider.dart';

class Refresh extends StatelessWidget {
  final Widget child;
  const Refresh({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final storiesBloc = StoriesProvider.of(context);

    return RefreshIndicator(
      child: child,
      onRefresh: () async {
        // cache clear
        await storiesBloc.clearCache(); // await :  repository 의 await 에 대응
        // topIds 재요청 --> central transformer --> _itemsOutput.stream
        // 따라서 _itemsOutput.stream 을 구독하고 있는 StreamBuilder 재갱신
        await storiesBloc.fetchTopIds();
      },
    );
  }
}
