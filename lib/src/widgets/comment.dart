import 'dart:async';

import 'package:flutter/material.dart';

import '../models/item_model.dart';

class Comment extends StatelessWidget {
  final int itemId;
  final Map<int, Future<ItemModel>> itemMap;
  final int depth;

  const Comment({
    Key? key,
    required this.itemId,
    required this.itemMap,
    required this.depth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: itemMap[itemId],
      builder: (context, AsyncSnapshot<ItemModel> snapshot) {
        if (!snapshot.hasData) {
          return const Text('Loading comment...');
        }

        // recursive comments
        final item = snapshot.data;
        final children = <Widget>[
          ListTile(
            title: Text(item!.text),
            // 삭제된 댓글의 경우 by가 없음
            subtitle: item.by == '' ? const Text('Deleted') : Text(item.by),
            contentPadding: EdgeInsets.only(
              right: 16.0,
              left: (depth == 0) ? 16.0 : depth * 16.0,
            ),
          ),
          const Divider(),
        ];
        for (var kidId in item.kids) {
          children.add(
            Comment(
              itemId: kidId,
              itemMap: itemMap,
              depth: depth + 1, // 매 comment 의 kidIds 는 depth 증가
            ),
          );
        }
        return Column(
          children: children,
        );
      },
    );
  }
}
