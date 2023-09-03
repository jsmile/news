import 'dart:async';

import 'news_db_provider.dart';
import 'news_api_provider.dart';
import '../models/item_model.dart';

class Repository {
  NewsDbProvider dbProvider = NewsDbProvider();
  NewsApiProvider apiProvider = NewsApiProvider();

  // fetchTopIds
  Future<List<int>> fetchTopIds() {
    return apiProvider.fetchTopIds();
  }

  // fetchItem
  Future<ItemModel?> fetchItem(int id) async {
    // 1. DB 에서 fetch
    var item = await dbProvider.fetchItem(id);
    if (item == null) {
      // 2. DB 에 없으면 API 에서 fetch
      item = await apiProvider.fetchItem(id);
      // 3. API 에서 fetch 한 결과를 DB 에 저장
      dbProvider.addItem(item); // DB 저장이 완료될 때까지 기다리지 않음.
      // await dbProvider.addItem(item); // DB 저장이 완료될 때까지 기다림.
    }

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
