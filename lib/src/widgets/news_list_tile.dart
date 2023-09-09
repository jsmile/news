import 'package:flutter/material.dart';
import 'dart:async';

import '../blocs/stories_bloc/stories_provider.dart';
import '../models/item_model.dart';

class NewsListTile extends StatelessWidget {
  final int itemId;

  const NewsListTile({required this.itemId, super.key});

  @override
  Widget build(BuildContext context) {
    StoriesBloc bloc = StoriesProvider.of(context);
    return StreamBuilder<Map<int, Future<ItemModel>>>(
      // stream: bloc.cachedItemsSubject,
      // cachedItemsSubject 대신 transformer 중복 실행 방지가 처리된 _itemOutput 사용
      stream: bloc.items,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
        if (!snapshot.hasData) {
          return const Text('Stream still loading');
        }
        // 계속되는 Stream event 를 Async 로 1회만 처리하고 종료하기 위해 FutureBuilder 사용
        // 계속되는 Stream event 를 연속적으로 사용해야 할 때에는 사용하지 않음.
        return FutureBuilder<ItemModel>(
          future: snapshot.data![itemId],
          builder: (context, AsyncSnapshot<ItemModel> itemSnapshot) {
            if (!itemSnapshot.hasData) {
              return Text('Still loading item $itemId');
            }

            return Text(itemSnapshot.data!.title);
          },
        );
      },
    );
  }
}
