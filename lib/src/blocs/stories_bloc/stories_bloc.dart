import 'package:rxdart/rxdart.dart';

import './stories_provider.dart';
import '../../models/item_model.dart';
import '../../resources/repository.dart';

class StoriesBloc {
  // Repository
  final _repository = Repository();
  // Subject( = StreamController ) 구하기
  final _topIdsSubject = PublishSubject<List<int>>();
  // Stream 구하기
  get topIds => _topIdsSubject.stream;

  // topIds 가 사용자의 직접적인 input 이 아니라 외부에서 불러온 것이므로
  // stream 에 직접적으로 sink 를 추가하지 않고, fetchTopIds() 에서 sink 를 추가함.
  fetchTopIds() async {
    // Repository를 이용하여 외부로부터 topids 를 구한 뒤
    final ids = await _repository.fetchTopIds();
    // 변화된 값을 sink 를 통해 stream 에 추가함.
    _topIdsSubject.sink.add(ids);
  }

  dispose() {
    _topIdsSubject.close();
  }
}
