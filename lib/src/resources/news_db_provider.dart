import 'package:sqflite/sqflite.dart'; // only mobile devices support
import 'package:path_provider/path_provider.dart'; // for mobile devices directory
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';

import '../models/item_model.dart';

class NewsDbProvider {
  late Database db; // DB instance 선언

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

  // fetchItem
  dynamic fetchItem(int id) async {
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
  Future<int> addItem(ItemModel item) async {
    return await db.insert("ItemModel", item.toMapForDbItemModel());
  }
}
