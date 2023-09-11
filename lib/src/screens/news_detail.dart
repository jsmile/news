import 'package:flutter/material.dart';

import '../blocs/comments/comments_provider.dart';
import '../models/item_model.dart';

// 전달받은 것을 사용할 뿐
// itemId 를 내부에서 변경시키지 않으므로 StatelessWidget 사용
class NewsDetail extends StatelessWidget {
  final int itemId;

  const NewsDetail({super.key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    // 상세정보 댓글 조회를 위해 commentsBloc 구하기
    final commentsBloc = CommentsProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
      ),
      body: buildDetailBody(commentsBloc),
    );
  }

  Widget buildDetailBody(CommentsBloc bloc) {
    return StreamBuilder(
      stream: bloc.itemWithCommentsStream,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
        if (!snapshot.hasData) {
          return const Text('Loading ....');
        }

        final itemFuture = snapshot.data![itemId];
        return FutureBuilder(
            future: itemFuture,
            builder: (context, AsyncSnapshot<ItemModel> itemSnapshot) {
              if (!itemSnapshot.hasData) {
                return const Text('Loading ....');
              }
              return buildTitle(itemSnapshot.data!);
            });
      },
    );
  }

  Widget buildTitle(ItemModel item) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      // alignment : Container 의 child 가 width를 100% 로 사용할 수 있도록 설정
      alignment: Alignment.topCenter,
      child: Text(
        item.title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
