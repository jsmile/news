import 'package:rxdart/rxdart.dart';

import './stories_provider.dart';
import '../../models/item_model.dart';
import '../../resources/repository.dart';

///
/// Bloc - data 의 변화를 stream 에 반영하는 역할
///
class StoriesBloc {
  // data를 구할 수 있는 Repository 선언
  final _repository = Repository();
  // Subject( = rxdart 의 StreamController ) 선언
  final _topIdsSubject = PublishSubject<List<int>>();
  // Stream 구하기
  get topIds => _topIdsSubject.stream;

  // topIds 가 사용자의 직접적인 input 이 아니라 외부에서 불러온 것이므로
  // stream 에 직접적으로 sink 를 추가하지 않고, fetchTopIds() 에서 sink 를 추가함.
  fetchTopIds() async {
    // Repository를 이용하여 외부로부터 data( topids )를 구한 뒤
    final ids = await _repository.fetchTopIds();
    // 변화된 data( 값 )을 sink.add 를 통해 stream 에 추가함.
    _topIdsSubject.sink.add(ids);
  }

  /// stream 의 event 를 map 으로 변환하여 반환
  /// - 복수개의 StreamBuidler 사용에 대응
  _itemsTransformer() {
    return ScanStreamTransformer(
      // stream event 가 발생할 때마다 실행되는 함수
      (Map<int, Future<ItemModel?>> cache, int id, index) {
        // cache: map, id: 매 event 마다 전달되는 data
        cache[id] = _repository.fetchItem(id); // map 에 data 추가
        return cache;
      },
      // 이 함수가 사용하는 초기값( empty map )
      <int, Future<ItemModel>>{},
    );
  }

  dispose() {
    _topIdsSubject.close();
  }
}
