import 'dart:async';

import 'package:flutter/material.dart';

import '../models/item_model.dart';
import '../utils/util_funcs.dart';
import 'loading_container.dart';

/// 하나의 commit 와 바로 하위의 kids 들의 commit 표시
class Comment extends StatelessWidget {
  // 상위 commit 를 위한 id
  final int itemId;
  // kids 를 찾기위해 반복해서 호출이 필요한 전체 cache map
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
    // FutureBuilder : 대상 data 가 Future<T> 인 경우에 사용됨
    return FutureBuilder(
      future: itemMap[itemId],
      builder: (context, AsyncSnapshot<ItemModel> snapshot) {
        if (!snapshot.hasData) {
          return const LoadingContainer();
        }

        // recursive comments
        final item = snapshot.data;
        final children = <Widget>[
          ListTile(
            title: Text(htmlEscapeToNormal(item!.text)),
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

  // // Html 용 특수문자를 일반문자로 변환
  // String htmlEscapeToNormal(String input, {bool escape = true}) {
  //   var table = const [
  //     ['&', '&amp;'],
  //     ['<', '&lt;'],
  //     ['>', '&gt;'],
  //     ['"', '&quot;'],
  //     ["'", '&#x27;'],
  //     ['\n\n', '<p>'],
  //     ['', '</p>'],
  //     ['/', '&#x2F;'],
  //     ['`', '&#96;'],
  //     ['=', '&#x3D;'],
  //   ];
  //   if (!escape) {
  //     table = table.reversed.toList();
  //   }
  //   for (var item in table) {
  //     input = input.replaceAll(item[1], item[0]);
  //   }
  //   return input;
  // }
}
