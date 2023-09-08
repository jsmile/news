import 'dart:async';

import 'news_db_provider.dart';
import 'news_api_provider.dart';
import '../models/item_model.dart';

class Repository {
  // Source list
  List<Source> sources = <Source>[
    // NewsDbProvider(),  // DB 를 중복하여 open 할 위험이 있음.
    newsDbProvider, // DB 가 중복되어 open 되는 것을 방지하기 위해 객체 참조 선언
    NewsApiProvider(),
  ];
  // Cache list
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

    // ItemModel 이 있는지 확인하여
    for (var source in sources) {
      var tempItem = await source.fetchItem(id);
      if (tempItem != null) {
        item = tempItem;
        break;
      }
    }

    // 찾은 ItemModel 을 cache 들에  저장하고
    for (var cache in caches) {
      cache.addItem(item);
    }

    // ItemModel 을 반환
    return item;
  }
}

abstract class Source {
  Future<List<int>> fetchTopIds();
  Future<ItemModel?> fetchItem(int id);
}

abstract class Cache {
  Future<int> addItem(ItemModel item);
}
