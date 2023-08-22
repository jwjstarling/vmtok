
/** 
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hive/hive.dart';

class ContentfulHiveSync {
  final String spaceId;
  final String accessToken;
  late Box<String> _contentBox;
  late Box<String> _syncUrlBox;

  ContentfulHiveSync({required this.spaceId, required this.accessToken});

  Future<void> sync() async {
    print("Contentful Hive Sync");

    _contentBox = await Hive.openBox<String>('contentBox');
    _syncUrlBox = await Hive.openBox<String>('syncUrlBox');

    String initialSyncUrl =
        'https://cdn.contentful.com/spaces/$spaceId/sync?access_token=$accessToken&initial=true';
    String syncUrl = _contentBox.get('nextSyncUrl') ?? initialSyncUrl;

    final response = await http.get(Uri.parse(syncUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> responseJSON = jsonDecode(response.body);

      if (syncUrl != initialSyncUrl) {
        List<dynamic> content = getContent();

        for (var item in responseJSON['items']) {
          String type = item['sys']['type'];
          String id = item['sys']['id'];

          //Do DeletedAssets aswell

          if (type == 'DeletedEntry') {
            _contentBox.delete(id);
          } else {
            _contentBox.put(id, jsonEncode(item));
          }
        }
      } else {
        for (var item in responseJSON['items']) {
          String id = item['sys']['id'];
          _contentBox.put(id, jsonEncode(item));
        }
      }

      String nextSyncUrl =
          '${responseJSON['nextSyncUrl']}&access_token=$accessToken';
      _syncUrlBox.put('nextSyncUrl', nextSyncUrl);
    } else {
      throw Exception('Failed to load data');
    }
  }

  dynamic getContentById(String id) {
    return _contentBox.get(id);
  }

  List<dynamic> getContent() {
    List<String> keys = _contentBox.keys.cast<String>().toList();
    return keys.map((key) => jsonDecode(_contentBox.get(key)!)).toList();
  }

  void close() {
    _contentBox.close();
    _syncUrlBox.close();
  }
}
*/