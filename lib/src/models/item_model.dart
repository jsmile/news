import 'dart:convert';

import 'package:equatable/equatable.dart';

class ItemModel extends Equatable {
  final int id;
  final bool deleted;
  final String type;
  final String by;
  final int time;
  final String text;
  final bool dead;
  final int parent;
  final List<dynamic> kids;
  final String url;
  final int score;
  final String title;
  final int descendants;

  const ItemModel({
    required this.id,
    required this.deleted,
    required this.type,
    required this.by,
    required this.time,
    required this.text,
    required this.dead,
    required this.parent,
    required this.kids,
    required this.url,
    required this.score,
    required this.title,
    required this.descendants,
  });

  // ItemModel.fromJson(Map<String, dynamic> parsedJson)
  //     : id = parsedJson['id'],
  //       deleted = parsedJson['deleted'],
  //       type = parsedJson['type'],
  //       by = parsedJson['by'],
  //       time = parsedJson['time'],
  //       text = parsedJson['text'],
  //       dead = parsedJson['dead'],
  //       parent = parsedJson['parent'],
  //       kids = parsedJson['kids'],
  //       url = parsedJson['url'],
  //       score = parsedJson['score'],
  //       title = parsedJson['title'],
  //       descendants = parsedJson['descendants'];

  @override
  List<Object> get props {
    return [
      id,
      deleted,
      type,
      by,
      time,
      text,
      dead,
      parent,
      kids,
      url,
      score,
      title,
      descendants,
    ];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'deleted': deleted ? 1 : 0,
      'type': type,
      'by': by,
      'time': time,
      'text': text,
      'dead': dead ? 1 : 0,
      'parent': parent,
      'kids': jsonEncode(kids),
      'url': url,
      'score': score,
      'title': title,
      'descendants': descendants,
    };
  }

  ///
  /// Api 로부터 Map 을 받아 ItemModel 을 생성
  ///
  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: map['id'],
      deleted: map['deleted'] ?? false,
      type: map['type'],
      by: map['by'],
      time: map['time'],
      text: map['text'] ?? '',
      dead: map['dead'] ?? false,
      parent: map['parent'] ?? 0,
      // kids: List<int>.from(map['kids']),
      kids: map['kids'] ?? [],
      url: map['url'],
      score: map['score'],
      title: map['title'],
      descendants: map['descendants'],
    );
  }

  // factory ItemModel.fromMap(Map<String, dynamic> map) {
  //   return ItemModel(
  //     id: int.parse(map['id'] ?? 0),
  //     deleted: map['deleted'] ?? false,
  //     type: map['type'] ?? '',
  //     by: map['by'] ?? '',
  //     time: int.parse(map['time'] ?? 0),
  //     text: map['text'] ?? '',
  //     dead: map['dead'] ?? false,
  //     parent: int.parse(map['parent'] ?? 0),
  //     kids: List<int>.from(map['kids']),
  //     url: map['url'] ?? '',
  //     score: int.parse(map['score'] ?? 0),
  //     title: map['title'] ?? '',
  //     descendants: int.parse(map['descendants'] ?? 0),
  //   );
  // }

  ///
  /// DB 로부터 Map 을 받아 ItemModel 을 생성
  ///
  factory ItemModel.fromDB(Map<String, dynamic> map) {
    return ItemModel(
      id: map['id']?.toInt() ?? 0,
      deleted: map['deleted'] == 1,
      type: map['type'] ?? '',
      by: map['by'] ?? '',
      time: map['time']?.toInt() ?? 0,
      text: map['text'] ?? '',
      dead: map['dead'] == 1,
      parent: map['parent']?.toInt() ?? 0,
      // kids: jsonDecode(map['kids']),
      kids: jsonDecode(map['kids']),
      // Blob to List<int>
      url: map['url'] ?? '',
      score: map['score']?.toInt() ?? 0,
      title: map['title'] ?? '',
      descendants: map['descendants']?.toInt() ?? 0,
    );
  }

  ///
  /// DB 로부터 생성된 ItemModel 을 Map 으로 변환
  ///
  Map<String, dynamic> toMapForDbItemModel() {
    return {
      'id': id,
      'deleted': deleted ? 1 : 0,
      'type': type,
      'by': by,
      'time': time,
      'text': text,
      'dead': dead ? 1 : 0,
      'parent': parent,
      'kids': jsonEncode(kids),
      'url': url,
      'score': score,
      'title': title,
      'descendants': descendants,
    };
  }

  String toJson() => json.encode(toMap());

  factory ItemModel.fromJson(String source) =>
      ItemModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ItemModel(id: $id, deleted: $deleted, type: $type, by: $by, time: $time, text: $text, dead: $dead, parent: $parent, kids: $kids, url: $url, score: $score, title: $title, descendants: $descendants)';
  }
}
