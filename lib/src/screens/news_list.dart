import 'package:flutter/material.dart';

import '../blocs/stories_bloc/stories_provider.dart';
import '../widgets/news_list_tile.dart';
import '../widgets/refresh.dart';

class NewsList extends StatelessWidget {
  const NewsList({super.key});

  @override
  Widget build(BuildContext context) {
    final storiesBloc = StoriesProvider.of(context);
    // // Just for testing
    // // It's very very bad code
    // storiesBloc.fetchTopIds();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Top News'),
      ),
      body: buildList(storiesBloc),
    );
  }
}

Widget buildList(StoriesBloc storiesBloc) {
  // return StreamBuilder(
  //   stream: storiesBloc.topIds,
  //   builder: (context, snapshot) {
  //     if (snapshot.hasData) {
  //       return ListView.builder(
  //         // itemCount: snapshot.data.length,
  //         // itemCount: (snapshot.data as List?)?.length ?? 0,  // null 대응
  //         itemCount: (snapshot.data as List).length, // null 대응
  //         itemBuilder: (context, index) {
  //           // return Text(snapshot.data[index]);
  //           // return Text((snapshot.data as List<String>?)?[index] ?? ''); // null 대응
  //           // return Text('${(snapshot.data as List<int>)[index]}'); // null 대응
  //           return NewsListTile(itemId: snapshot.data[index]); // [] conditional error
  //         },
  //       );
  //     }

  //     return const Center(
  //       child: CircularProgressIndicator(
  //         color: Colors.blue,
  //       ),
  //     );
  //   },
  // );

  return StreamBuilder<List<int>>(
    // topIds stream 구독
    stream: storiesBloc.topIds,
    // snapshot: AsyncSnapshot<List<int>>
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        // RefeshIndicator 적용
        return Refresh(
          child: ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              // cached itemMap 를 위한 stream 활성화( sink.add )
              storiesBloc.addItem(snapshot.data![index]);
              return NewsListTile(
                itemId: snapshot.data![index],
              );
            },
          ),
        );
      }

      return const Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
        ),
      );
    },
  );
}
