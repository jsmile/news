import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart'; // for mobile devices directory
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';

import '../models/item_model.dart';

class NewsDbProvider {
  Database db;

  // async contructor
  init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'item.db');
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database newDb, int version) {},
    );
  }
}
