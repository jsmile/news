import 'dart:async';

import 'package:flutter/material.dart';

import '../models/item_model.dart';

class Comment extends StatelessWidget {
  final int itemId;
  final Map<int, Future<ItemModel>> itemMap;

  const Comment({
    Key? key,
    required this.itemId,
    required this.itemMap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: itemMap[itemId],
      builder: (context, AsyncSnapshot<ItemModel> snapshot) {
        if (!snapshot.hasData) {
          return const Text('Loading comment...');
        }

        return Text(snapshot.data!.text);
      },
    );
  }
}
