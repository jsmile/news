import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' show Client;

import './repository.dart';

import '../models/item_model.dart';
import '../utils/ansi_color.dart';

///
/// 외부( API )로부터 Data 를 가져오는 Provider
///
class NewsApiProvider implements Source {
  final Client client = Client();

  @override
  Future<List<int>> fetchTopIds() async {
    Uri uri = Uri.parse(
      'https://hacker-news.firebaseio.com/v0/topstories.json',
    );
    final response = await client.get(uri);
    debugPrint(success('### response.body: ${response.body}'));
    final ids = json.decode(response.body);

    // cast<T>() : T type 의 List 반환 :   List<dynamic> -> List<int>
    return ids.cast<int>();
  }

  @override
  Future<ItemModel> fetchItem(int id) async {
    Uri uri = Uri.parse('https://hacker-news.firebaseio.com/v0/item/$id.json');
    final response = await client.get(uri);
    debugPrint(success('### response.body: ${response.body}'));

    final parsedJson = json.decode(response.body);
    return ItemModel.fromMap(parsedJson);
  }
}
