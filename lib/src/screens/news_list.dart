import 'package:flutter/material.dart';
import 'package:news/src/blocs/stories_bloc/stories_bloc.dart';

import '../blocs/stories_bloc/stories_provider.dart';

class NewsList extends StatelessWidget {
  const NewsList({super.key});

  @override
  Widget build(BuildContext context) {
    final storiesBloc = StoriesProvider.of(context);
    // Just for testing
    // It's very very bad code
    storiesBloc.fetchTopIds();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Top News'),
      ),
      body: buildList(storiesBloc),
    );
  }
}

Widget buildList(StoriesBloc storiesBloc) {
  return StreamBuilder(
    stream: storiesBloc.topIds,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return ListView.builder(
          // itemCount: snapshot.data.length,
          // itemCount: (snapshot.data as List?)?.length ?? 0,  // null 대응
          itemCount: (snapshot.data as List).length, // null 대응
          itemBuilder: (context, index) {
            // return Text(snapshot.data[index]);
            // return Text((snapshot.data as List<String>?)?[index] ?? ''); // null 대응
            return Text('${(snapshot.data as List<int>)[index]}'); // null 대응
          },
        );
      }

      return const Text('Still waitting on Ids.....');
    },
  );
}