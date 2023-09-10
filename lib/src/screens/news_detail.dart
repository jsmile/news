import 'package:flutter/material.dart';

// 전달받은 것을 사용할 뿐
// itemId 를 내부에서 변경시키지 않으므로 StatelessWidget 사용
class NewsDetail extends StatelessWidget {
  final int itemId;

  const NewsDetail({super.key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
      ),
      body: Text('$itemId'),
    );
  }
}
