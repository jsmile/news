import 'package:sqflite/sqflite.dart'; // only mobile devices support
import 'package:path_provider/path_provider.dart'; // for mobile devices directory
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';

import '../models/item_model.dart';
import './repository.dart';

///
/// 외부( DB ) Data 작업을 처리하는 Provider
///
class NewsDbProvider implements Source, Cache {
  late Database db; // DB instance 선언

  NewsDbProvider() {
    init(); // async constructor
  }

  // async contructor
  init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'item.db'); // DB 생성
    db = await openDatabase(
      // DB 연결
      path,
      version: 1,
      onCreate: (Database newDb, int version) {
        // Table 생성
        newDb.execute('''
          CREATE TABLE Items
            (
              id INTEGER PRIMARY KEY,
              type TEXT,
              by TEXT,
              time INTEGER,
              text TEXT,
              parent INTEGER,
              kids BLOB,
              dead INTEGER,
              deleted INTEGER,
              url TEXT,
              score INTEGER,
              title TEXT,
              descendants INTEGER
            )
          ''');
      },
    );
  }

  // abstract class 의 형식을 맞춰주기 위해 null 을 반환함
  @override
  Future<List<int>> fetchTopIds() {
    // Future(() => <int>[]) : Future type으로 List<init> 의 null 을 반환하는 방법
    return Future(() => <int>[]);
  }

  // fetchItem
  // Future<ItemModel?> : Future<ItemMode> 의 null 을 반환하는 방법
  @override
  Future<ItemModel?> fetchItem(int id) async {
    final maps = await db.query(
      'Items',
      columns: null, // null means all columns
      where: 'id=?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return ItemModel.fromDB(maps.first);
    }

    return null;
  }

  // 처리결과에 관심이 있으면 Future<int> 로 선언한다.
  @override
  Future<int> addItem(ItemModel item) async {
    return await db.insert("Item", item.toMapForDbItemModel());
  }
}

// NewsDbProvider의 DB 중복해서 open 하지 않도록
// NewsDbProvider 의 instance 를 생성하여 export
final newsDbProvider = NewsDbProvider();
