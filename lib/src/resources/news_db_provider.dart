import 'package:sqflite/sqflite.dart'; // only mobile devices support
import 'package:path_provider/path_provider.dart'; // for mobile devices directory
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';

import '../models/item_model.dart';
import './repository.dart'; // abstract class Source, Cache 를 참조하기 위해 import

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
    final path = join(documentsDirectory.path, 'items.db'); // DB 생성 경로

    print('#############################');
    print('### DB Directory Path : $path');
    print('#############################');

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
    // Future(() => <int>[]) : Future type으로 List<int> 의 null 을 반환하는 방법
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
    return await db.insert(
      "Items",
      item.toDbMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore, // 중복된 데이터는 무시
    );
  }

  // Table 의 data 제거
  @override
  Future<int> clear() {
    return db.delete('Items');
  }

  // https://pub.dev/packages/sqflite
  // // Insert some records in a transaction
  // await database.transaction((txn) async {
  //   int id1 = await txn.rawInsert(
  //       'INSERT INTO Test(name, value, num) VALUES("some name", 1234, 456.789)');
  //   print('inserted1: $id1');
  //   int id2 = await txn.rawInsert(
  //       'INSERT INTO Test(name, value, num) VALUES(?, ?, ?)',
  //       ['another name', 12345678, 3.1416]);
  //   print('inserted2: $id2');
  // });

  // // Update some record
  // int count = await database.rawUpdate(
  //     'UPDATE Test SET name = ?, value = ? WHERE name = ?',
  //     ['updated name', '9876', 'some name']);
  // print('updated: $count');

  // // Get the records
  // List<Map> list = await database.rawQuery('SELECT * FROM Test');
}

// NewsDbProvider의 DB 중복해서 open 하지 않도록
// NewsDbProvider 의 instance 를 생성하여 export
final newsDbProvider = NewsDbProvider();
