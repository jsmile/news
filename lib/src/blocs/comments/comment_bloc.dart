import 'dart:async';
import 'package:rxdart/rxdart.dart';

import '../../models/item_model.dart';
import '../../resources/repository.dart';

class CommentsBloc {
  // data를 구할 수 있는 Repository 선언
  final _repository = Repository();
  // for temp Stream
  final _commentsFetcher = PublishSubject<int>();
  // for output stream of center transformer
  final _commentsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();

  // central transformer 를 위한 constructor
  CommentsBloc() {
    _commentsFetcher.stream
        .transform(_commentsTransformer())
        .pipe(_commentsOutput);
  }

  // 외부 공개 Stream getter
  Stream<Map<int, Future<ItemModel>>> get itemWithCommentsStream =>
      _commentsOutput.stream;
  // temp Stream sink.add getter
  Function(int) get addFetchItemWithComments => _commentsFetcher.sink.add;

  // central transformer
  _commentsTransformer() {
    // // 방법 1 :  StreamTransformer<S,T>.fromHandlers()
    // return StreamTransformer<int, Map<int, Future<ItemModel>>>.fromHandlers(
    //     handleData: (int id, EventSink<Map<int, Future<ItemModel>>> sink) {
    //   final cache = _commentsOutput.value ?? <int, Future<ItemModel>>{};
    //   if (!cache.containsKey(id)) {
    //     cache[id] = _repository.fetchItem(id);
    //     cache[id]!.then((ItemModel item) {
    //       for (var kidsId in item.kids) {
    //         addFetchItemWithComments(kidsId);
    //       }
    //     });
    //   }
    //   sink.add(cache);
    // });

    // 방법 2 : ScanStreamTransformer<S,T>
    return ScanStreamTransformer<int, Map<int, Future<ItemModel>>>(
      (cache, int id, index) {
        print('### index : $index');
        cache[id] = _repository.fetchItem(id);
        // recursive call
        cache[id]!.then((ItemModel item) {
          // forEach() 에서는 await 를 사용할 수 없으므로 즉 Future 반환 X
          // item.kids.forEach((kidsId) => addFetchItemWithComments(kidsId));

          for (var kidsId in item.kids) {
            // kidsId 를 사용하여 바로 _commentsFetcher Stream 에 sink 하여 재귀호출
            addFetchItemWithComments(kidsId);
          }
        });
        return cache;
      },
      <int, Future<ItemModel>>{},
    );
  }

  // dispos
  dispose() {
    _commentsFetcher.close();
    _commentsOutput.close();
  }
}
