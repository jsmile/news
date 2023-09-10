import 'dart:async';

import 'news_db_provider.dart';
import 'news_api_provider.dart';
import '../models/item_model.dart';

class Repository {
  // data 조회와 저장을 하는 Provider 가 구분되므로 Source 와 Cache 를 분리함.
  List<Source> sources = <Source>[
    // NewsDbProvider(),  // DB 를 중복하여 open 할 위험이 있음.
    newsDbProvider, // DB 가 중복되어 open 되는 것을 방지하기 위해 객체 참조 선언
    NewsApiProvider(),
  ];

  List<Cache> caches = <Cache>[
    newsDbProvider, // DB 가 중복되어 open 되는 것을 방지하기 위해 객체 참조 선언
  ];

  // fetchTopIds
  Future<List<int>> fetchTopIds() {
    // return apiProvider.fetchTopIds();
    return sources[1].fetchTopIds(); // 특정 Source 에서만 fetchTopIds 를 수행하도록 함
  }

  // 복수개의 Source list 에서 for loop 를 돌며 fetchItem 을 반복하여 수행
  Future<ItemModel> fetchItem(int id) async {
    late ItemModel item;
    var source; // cache 와 비교하기 쉽게 하기 위해 type 없이 var 로 선언

    // ItemModel 이 있는지 확인하여
    for (source in sources) {
      var tempItem = await source.fetchItem(id);
      if (tempItem != null) {
        item = tempItem;
        break;
      }
    }

    // 찾은 ItemModel 을 cache 들에  저장하고
    for (var cache in caches) {
      // cache.addItem(item);
      // 동일한 source 에 읽었다가 다시 쓰는 것을 방지함.( Unique Contraint failed 대응 )
      if (cache != source) {
        cache.addItem(item);
      }
    }

    // ItemModel 을 반환
    return item;
  }

  // clearCache : RefreshIndicator() 에 의해 사용됨
  clearCache() async {
    for (var cache in caches) {
      await cache.clear(); // await : future<int> 대응
    }
  }
}

abstract class Source {
  Future<List<int>> fetchTopIds();
  Future<ItemModel?> fetchItem(int id);
}

abstract class Cache {
  Future<int> addItem(ItemModel item);
  Future<int> clear();
}
