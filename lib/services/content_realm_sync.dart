import 'package:http/http.dart' as http;
import 'dart:convert';

/**
class ContentfulRealmSync {
  final String spaceId;
  final String accessToken;
  // Assuming Realm has a Realm object or similar for Flutter
  late final Realm _realm;

  ContentfulRealmSync({required this.spaceId, required this.accessToken});

  Future<void> sync() async {
    // Open a Realm. This might be different in the Flutter SDK.
    _realm = await Realm.open();

    String initialSyncUrl =
        'https://cdn.contentful.com/spaces/$spaceId/sync?access_token=$accessToken&initial=true';
    String syncUrl = _realm.objectForPrimaryKey('nextSyncUrl') ?? initialSyncUrl;

    final response = await http.get(Uri.parse(syncUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> responseJSON = jsonDecode(response.body);

      _realm.write(() {
        if (syncUrl != initialSyncUrl) {
          for (var item in responseJSON['items']) {
            String type = item['sys']['type'];
            String id = item['sys']['id'];

            if (type == 'DeletedEntry') {
              _realm.deleteObjectWithPrimaryKey(id);
            } else {
              // Assuming you have a ContentfulItem class or similar
              _realm.createOrUpdate('ContentfulItem', item);
            }
          }
        } else {
          for (var item in responseJSON['items']) {
            _realm.create('ContentfulItem', item);
          }
        }

        String nextSyncUrl =
            '${responseJSON['nextSyncUrl']}&access_token=$accessToken';
        // Store the nextSyncUrl in a separate object or similar
        _realm.createOrUpdate('SyncUrl', {'id': 'nextSyncUrl', 'url': nextSyncUrl});
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  dynamic getContentById(String id) {
    return _realm.objectForPrimaryKey('ContentfulItem', id);
  }

  List<dynamic> getContent() {
    return _realm.objects('ContentfulItem').toList();
  }

  void close() {
    _realm.close();
  }
}
 */